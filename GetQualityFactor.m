function quality=GetQualityFactor(quant_tables)
% 得到JPEG信息

QT = [16 11  10  16  24  40  51  61        % JPEG normalizing array
    12  12  14  19  26  58  60  55       % and zig-zag redordering
    14  13  16  24  40  57  69  56       % pattern.
    14  17  22  29  51  87  80  62
    18  22  37  56  68  109 103 77
    24  35  55  64  81  104 113 92
    49  64  78  87  103 121 120 101
    72  92  95  98  112 100 103 99];
quality=mean(mean(quant_tables./QT));
if (quality<=1)
    quality=round((2-quality)*50);
else
    quality=round(50/quality);
end
    if(quality>=98)
        Q100_table=jpeg_qtable(100);
        Q99_table=jpeg_qtable(99);
        Q98_table=jpeg_qtable(98);
        diff100=sum(sum(abs(quant_tables-Q100_table)));
        diff99=sum(sum(abs(quant_tables-Q99_table)));
        diff98=sum(sum(abs(quant_tables-Q98_table)));
        if(diff100<diff99)
           if(diff100<diff98)
               quality=100;
           else
               quality=98;
           end
        else
            if(diff99<diff98)
                quality=99;
            else
                quality=98;
            end
        end
    end
    
end