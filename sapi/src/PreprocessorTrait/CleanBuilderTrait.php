<?php

declare(strict_types=1);

namespace SwooleCli\PreprocessorTrait;

trait CleanBuilderTrait {
    public function show_ext_eps_file(string $ext_name):void
    {
        var_dump(array_keys($this->extensionDependentLibraryMap));
    }
}
