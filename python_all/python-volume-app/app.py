with open("/data/demo.txt","w") as file:
    file.write("Hello Docker volume")



#docker volume create python-data
#docker build -t pyvolumeapp .
#docker run -d --name c2 -p 5000:5000 -v python-data:/data pyvolumeapp
#docker exec -it python-container bash

#docker run -it --name second-container -v python-data:/data ubuntu bash