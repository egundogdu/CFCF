function output = grabTheGTRect(GT, frame)
    region = GT(frame,:);
    if numel(region) > 4
        % Init with an axis aligned bounding box with correct area and center
        % coordinate
        cx = mean(region(1:2:end));
        cy = mean(region(2:2:end));
        x1 = min(region(1:2:end));
        x2 = max(region(1:2:end));
        y1 = min(region(2:2:end));
        y2 = max(region(2:2:end));
        A1 = norm(region(1:2) - region(3:4)) * norm(region(3:4) - region(5:6));
        A2 = (x2 - x1) * (y2 - y1);
        s = sqrt(A1/A2);
        w = s * (x2 - x1) + 1;
        h = s * (y2 - y1) + 1;
    else
        cx = region(1) + (region(3) - 1)/2;
        cy = region(2) + (region(4) - 1)/2;
        w = region(3);
        h = region(4);
    end
    
    output = [cx-w/2 cy-h/2 w h];

end