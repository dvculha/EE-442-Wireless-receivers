function [preamble] = preamble_generate(length)
% preamble_generate() 
% input : length: a scaler value, desired length of preamble.
% output: preamble: preamble bits



    preamble = zeros(length, 1);
    % initialize w all ones
    register = ones(8,1);
    
    % length = 100
    for i=length:-1:1
        %generating the preamble
        % first of preamble is the last of register
        preamble(i)=register(end);
        tmp = xor(register(end),register(end-2));
        tmp = xor(tmp,register(end-3));
        tmp = xor(tmp,register(end-4));
        %shift of the bits in the register by one to the right
        register = circshift(register,1);
        register(1)=tmp;
        
        
    end
    
    preamble = flip(preamble);

end