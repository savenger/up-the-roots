PROJECT_NAME="up-the-roots"

# make windows zip file
echo "making windows zip file..."
#rm -f ${PROJECT_NAME}_win.zip
#zip ${PROJECT_NAME}_win.zip ${PROJECT_NAME}_win/${PROJECT_NAME}.exe ${PROJECT_NAME}_win/${PROJECT_NAME}.pck
#scp ${PROJECT_NAME}_win.zip savenger:/data/netshare/24

# make linux tar archive
#echo "making linux tar file..."
#tar czf ${PROJECT_NAME}_linux.tar.gz ${PROJECT_NAME}_linux/${PROJECT_NAME}.x86_64 ${PROJECT_NAME}_linux/${PROJECT_NAME}.pck

# make complete zip
echo "making all-OS zip file..."
#rm -f ${PROJECT_NAME}_all.zip
#zip ${PROJECT_NAME}_all.zip ${PROJECT_NAME}_win/${PROJECT_NAME}.exe ${PROJECT_NAME}_win/${PROJECT_NAME}.pck ${PROJECT_NAME}_linux/${PROJECT_NAME}.x86_64 ${PROJECT_NAME}_linux/${PROJECT_NAME}.pck

# make html zip
echo "making html zip file..."
rm -rf ${PROJECT_NAME}_html.zip
cd ${PROJECT_NAME}_html5 && zip ../${PROJECT_NAME}_html.zip *
cd ..

# make source tar archive
echo "making source tar file"
rm -rf ${PROJECT_NAME}_src.tar.gz
cd ~/workspace/godot/ && tar --exclude=.git --exclude=.import -czf /tmp/${PROJECT_NAME}_src.tar.gz ${PROJECT_NAME}
