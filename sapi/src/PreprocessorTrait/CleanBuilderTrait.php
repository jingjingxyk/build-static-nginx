<?php

declare(strict_types=1);

namespace SwooleCli\PreprocessorTrait;

trait CleanBuilderTrait
{
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

        $exts = $this->extensionMap[$ext_name]->dependentExtensions;
        foreach ($exts as $key => $ext) {
            echo $ext . PHP_EOL;
            $exts[$key] = $ext . '.php';
        }
        echo "=================" . PHP_EOL;
        echo "依赖的库: " . PHP_EOL;
        $libs = $this->extensionDependentLibraryMap[$ext_name];
        foreach ($libs as $key => $lib) {
            echo $lib . PHP_EOL;
            $libs[$key] = $lib . '.php';
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
}
