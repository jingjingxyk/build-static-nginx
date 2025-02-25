<?php

declare(strict_types=1);

namespace SwooleCli\PreprocessorTrait;

trait CleanBuilderTrait
{
    private $clean_builder_libs = [];
    private $clean_builder_exts = [];

    public function show_ext_deps(string $ext_name): void
    {
        $project_dir = realpath(__DIR__ . '/../../../');
        $ext_is_exists = 0;
        $all_ext_builder = scandir($project_dir . '/sapi/src/builder/extension/');
        $new_all_ext_builder = [];
        foreach ($all_ext_builder as $file) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            if (preg_match('/\.php$/', $file)) {
                if ($file === $ext_name . '.php') {
                    $ext_is_exists = 1;
                }
                $new_all_ext_builder [] = $file;
            }
        }
        $all_library_builder = scandir($project_dir . '/sapi/src/builder/library/');
        $new_all_library_builder = [];
        foreach ($all_library_builder as $file) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            if (preg_match('/\.php$/', $file)) {
                $new_all_library_builder [] = $file;
            }
        }
        if ($ext_is_exists != 1) {
            echo 'no found ext name : ' . $ext_name;
            exit(0);
        }

        # 获得扩展依赖链
        $this->getDependentExtensionsByExtName($ext_name);
        # 获得库依赖链
        $this->getDependentLibraryByExtName($ext_name);


        echo "=================" . PHP_EOL;
        echo "依赖的扩展:" . PHP_EOL;
        foreach ($this->clean_builder_exts as $key => $ext) {
            echo $ext . PHP_EOL;
        }

        echo "=================" . PHP_EOL;
        echo "依赖的库: " . PHP_EOL;
        foreach ($this->clean_builder_libs as $key => $lib) {
            echo $lib . PHP_EOL;
        }
        //var_dump($this->clean_builder_exts);
        //var_dump($this->clean_builder_libs);

        echo "=================" . PHP_EOL;
        # 求差集 获得不需要的 builder
        $clean_ext_builder = array_diff($new_all_ext_builder, $this->clean_builder_exts);
        $clan_lib_builder = array_diff($new_all_library_builder, $this->clean_builder_libs);

        if ($this->getInputOption('with-clean-builder')) {
            $cmd = <<<EOF
cd {$project_dir}
git branch | grep '* ' | awk '{print $2}'
EOF;

            $branch_name = trim(shell_exec($cmd));
            if (!in_array($branch_name, [
                'build-swow-cli',
                'build_native_php',
                'build_native_php_sfx_micro',
                'build_php_7.3',
                'build_php_7.4',
                'build_php_8.0',
                'experiment',
                'experiment-feature',
                'experiment_v4.8.x',
                'new_dev',
                'php-fpm',
                'php-fpm-7.4'
            ])) {
                echo "执行清理 无关的 builder";
                foreach ($clean_ext_builder as $file) {
                    unlink($project_dir . '/sapi/src/builder/extension/' . $file);
                }
                foreach ($clan_lib_builder as $file) {
                    unlink($project_dir . '/sapi/src/builder/library/' . $file);
                }
            }
            echo "清理完毕" . PHP_EOL;
            exit(0);
        }
    }

    private function getDependentExtensionsByExtName($ext_name): void
    {
        $dependentExtensions = $this->extensionMap[$ext_name]->dependentExtensions;
        if (!empty($dependentExtensions)) {
            foreach ($dependentExtensions as $ext) {
                if (in_array($ext, $this->clean_builder_exts)) {
                    continue;
                } else {
                    $this->clean_builder_exts[] = $ext;
                }
                $this->getDependentExtensionsByExtName($ext);
            }
        }
    }

    private function getDependentLibraryByExtName($ext_name): void
    {
        $deps = $this->extensionMap[$ext_name]->deps;
        if (!empty($deps)) {
            foreach ($deps as $lib) {
                if (in_array($lib, $this->clean_builder_libs)) {
                    continue;
                }
                $this->clean_builder_libs[] = $lib;
                $this->getDependentLibraryByLibName($lib);
            }
        }

    }

    private function getDependentLibraryByLibName($lib_name): void
    {
        $deps = $this->libraryMap[$lib_name]->deps;
        if (!empty($deps)) {
            foreach ($deps as $lib) {
                if (in_array($lib, $this->clean_builder_libs)) {
                    continue;
                }
                $this->clean_builder_libs[] = $lib;
                $this->getDependentLibraryByLibName($lib);
            }
        }
    }


}
