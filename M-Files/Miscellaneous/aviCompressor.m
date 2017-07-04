function aviCompressor( filename )
%AVICOMPRESSER Compresses avi files 

reader = VideoReader( filename );
writer = VideoWriter('Compressed Video');

writer.FrameRate = reader.FrameRate;
open(writer);

while hasFrame(reader)
    img = readFrame(reader);
    writeVideo(writer,img);
end

close(writer);
delete filename

end

