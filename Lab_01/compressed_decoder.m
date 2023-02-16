function newimage = compressed_decoder(b,image_size)

% error handling
if length(b) ~= 8 * prod(image_size)
  error('Input vector has wrong size.')
end

% convert to uint8
b1 = reshape(b, 8, length(b)/8).';
image = bi2de(b1);

% reshape into image format
image = reshape(image, image_size(2), image_size(1)).';

% pad the image to multiples of 8
height  = ceil(image_size(1)/8)*8;
width   = ceil(image_size(2)/8)*8;
padded = zeros(height,width);
padded(1:image_size(1),1:image_size(2)) = image;

factor = 0.7;

% segment image into tiles
data = zeros(8*8,(width*height)/(8*8));
k = 1;

for rr=1:8:height % go through rows 
    for cc=1:8:width % go through columns
        patch       = padded(rr:rr+7,cc:cc+7);
        vector      = reshape(patch,8*8,1);
        data(:,k)   = vector;
        k = k + 1;
    end
end

% decompose 
[U S V]         = svd(data.',0);

% filter weak singular values 
fullsv              = diag(S);
compressedsv        = zeros(size(fullsv));
mask = cumsum(fullsv) < (factor*sum(fullsv));
compressedsv(mask)  = fullsv(mask);

SC = diag(compressedsv);

% compose
newdata = U*SC*V';
newpadded = zeros(height,width);
k = 1;

% assemble full image from patches
for rr=1:8:height % go through rows
    for cc=1:8:width % go through columns
        patch = newdata(k,:);
        newpadded(rr:rr+7,cc:cc+7) = reshape(patch,8,8);
        k = k + 1;
    end
end

% shrink to original size
newimage = newpadded(1:image_size(1),1:image_size(2));


end