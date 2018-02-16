function [ posx, posy,  WW, HH] = readXMLForILSVRC( currXMLObj )
    if length(currXMLObj.annotation.object)>1
        xmax = str2double(currXMLObj.annotation.object{1}.bndbox.xmax.Text);
        xmin = str2double(currXMLObj.annotation.object{1}.bndbox.xmin.Text);
        ymax = str2double(currXMLObj.annotation.object{1}.bndbox.ymax.Text);
        ymin = str2double(currXMLObj.annotation.object{1}.bndbox.ymin.Text);
    else
        xmax = str2double(currXMLObj.annotation.object.bndbox.xmax.Text);
        xmin = str2double(currXMLObj.annotation.object.bndbox.xmin.Text);
        ymax = str2double(currXMLObj.annotation.object.bndbox.ymax.Text);
        ymin = str2double(currXMLObj.annotation.object.bndbox.ymin.Text);
    end
    posx = floor((xmin+xmax)/2); posy = floor((ymin+ymax)/2);
    WW = 2*(xmax-xmin+1); HH = 2*(ymax-ymin+1);
end

