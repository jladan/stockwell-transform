function light_table(imdata,titles,varargin)

clf
n = ceil(length(imdata)/2);

for j = 1:length(imdata)
    subplot(2,n,j), imshow(imdata{j},varargin{:})
    ax(j) = gca;
    title(titles{j});
end
linkaxes(ax)
