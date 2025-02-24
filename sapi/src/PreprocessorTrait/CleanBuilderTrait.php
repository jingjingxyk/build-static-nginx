<?php

declare(strict_types=1);

namespace SwooleCli\PreprocessorTrait;

trait CleanBuilderTrait
{
    private $clean_builder_libs=[];
    private $clean_builder_exts=[];

    public function show_ext_deps(string $ext_name): void
    {
        $project_dir = realpath(__DIR__ . '/../../../');
        $ext_is_exists = 0;
        $ext_files = scandir($project_dir . '/sapi/src/builder/extension/');
        $new_ext_files = [];
        foreach ($ext_files as $file) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            if (preg_match('/\.php$/', $file)) {
                if ($file === $ext_name . '.php') {
                    $ext_is_exists = 1;
                }
                $new_ext_files [] = $file;
            }
        }
        $library_files = scandir($project_dir . '/sapi/src/builder/library/');
        $new_library_files = [];
        foreach ($library_files as $file) {
            if ($file == '.' || $file == '..') {
                continue;
            }
            if (preg_match('/\.php$/', $file)) {
                $new_library_files [] = $file;
            }
        }
        if ($ext_is_exists != 1) {
            echo 'no found ext name : ' . $ext_name;
            exit(0);
        }

        echo "=================" . PHP_EOL;
        echo "依赖的扩展:" . PHP_EOL;
        $this->getDependentExtensions($ext_name);
        die;
        $exts = $this->extensionMap[$ext_name]->dependentExtensions;
        $libs = $this->extensionMap[$ext_name]->deps;
        foreach ($exts as $key => $ext) {
            echo $ext . PHP_EOL;
            $exts[$key] = $ext . '.php';
            $this->clean_builder_libs +=$this->extensionMap[$ext]->deps;
            $this->clean_builder_exts +=$this->extensionMap[$ext_name]->dependentExtensions;
        }
        if (empty($exts)) {
            $exts = [];
        }
        echo "=================" . PHP_EOL;
        echo "依赖的库: " . PHP_EOL;

        $deps = $this->extensionMap[$ext_name]->deps;
        $libs = $this->extensionDependentLibraryMap[$ext_name];
        var_dump($deps);
        foreach ($libs as $key => $lib) {
            echo $lib . PHP_EOL;
            $libs[$key] = $lib . '.php';
        }
        if (empty($libs)) {
            $libs = [];
        }
        echo "=================" . PHP_EOL;
        # 求差集 （删除不依赖的扩展 或者 库）
        $clean_lib_builder = array_diff($new_library_files, $libs);
        $clan_ext_builder = array_diff($new_ext_files, $exts);

        if ($this->getInputOption('with-clean-deps-file')) {
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
                foreach ($clan_ext_builder as $file) {
                    unlink($project_dir . '/sapi/src/builder/extension/' . $file);
                }
                foreach ($clean_lib_builder as $file) {
                    unlink($project_dir . '/sapi/src/builder/library/' . $file);
                }
            }
            echo "清理完毕" . PHP_EOL;
            exit(0);
        }
    }

    private function getDependentExtensions($ext_name){
        $exts = $this->extensionMap[$ext_name]->dependentExtensions;
        $this->clean_builder_exts +=$exts;

        foreach ($exts as $name) {
            if(empty($this->extensionMap[$name]->dependentExtensions)){

            }else{
                $this->getDependentExtensions($name);
            }


        }
    }
    private function getDependentLibrary($lib): void
    {
        if (!isset($this->libraryMap[$lib])) {
            throw new RuntimeException('library ' . $lib. ' no found');
        }
        $lib = $this->libraryMap[$lib];
        if (!empty($lib->deps)) {
            $libs = array_merge($libs, $lib->deps);
            foreach ($lib->deps as $name) {
                $this->getLibraryDependentLibraryByName($name, $libs);
            }
        }
    }

}
