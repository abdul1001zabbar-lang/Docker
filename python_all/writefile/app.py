with open("demo.txt","w") as file:
    file.write("hello Docker")

print("file created successfully")


#docker build -t writeapp .
#docker run writeapp
#docker run --name mywritecontainer writeapp



#if want to read this file

#docker exec -it mywritecontainer bash
#do ls
# cat demo.txt
