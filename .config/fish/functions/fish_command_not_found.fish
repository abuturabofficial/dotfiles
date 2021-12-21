function fish_command_not_found
        set -l __packages (pkgfile --binaries --verbose -- $argv[1] 2>/dev/null)
        if test $status -eq 0
            printf "%s may be found in the following packages:\n" "$argv[1]"
            printf "  %s\n" $__packages
        else
            __fish_default_command_not_found_handler $argv[1]
        end
    
end
