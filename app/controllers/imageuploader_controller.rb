class ImageuploaderController < ApplicationController
  require 'fileutils'

  def create
  uploaded_io = params[:file]    
  if params[:file].present? && (params[:file].size/1024/1024) <= 5 
    file_name = StoriesHelper.transliterate_path(uploaded_io.original_filename)
    if ['.jpg','.png'].index(File.extname(file_name)).present?       
        story_path = "public/system/places/images/#{params['id']}"
        file_path = "#{story_path}/original"
        url = "/system/places/images/#{params['id']}/original/#{file_name}"
        temp = "#{file_path}/#{file_name}"

        # make sure the path to the file exists
        FileUtils.mkpath(File.dirname(temp))

        # save the file temporarily
        File.open(temp, 'wb') do |file|
          file.write(uploaded_io.read)   
        end
        
        # create the mobile versions
        if File.exists?(file_path)       
            Subexec.run "convert #{temp} -resize 640x427 #{Rails.root.join(story_path,'mobile_640',file_name)}"                
            Subexec.run "convert #{temp} -resize 1024x623 #{Rails.root.join(story_path,'mobile_1024',file_name)}"     
            render json: { image: { url: "#{url}" } }, content_type: "text/html"          
        else
            render json: {error: {message: "Original File is missing for thumbnails"}}, content_type: "text/html"
        end         
      else
        render json: {error: {message: "Invalid file type. Only .jpg, .png allowed"}}, content_type: "text/html"
      end
   else 
      render json: {error: {message: "File size is limited to 5MB"}}, content_type: "text/html"
   end
  end 
 
end
