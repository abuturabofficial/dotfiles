function ls --wraps='exa --icons --git' --description 'alias ls=exa --icons --git'
  exa --icons --git $argv; 
end
