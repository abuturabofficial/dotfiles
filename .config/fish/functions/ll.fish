function ll --wraps=ls --wraps='exa -lh --icons --git' --description 'alias ll=exa -lh --icons --git'
  exa -lh --icons --git $argv; 
end
