rm -rf .theos && rm -rf packages && find . -name '.DS_Store' -type f -delete && make package && scp -r ./packages/*.deb root@192.168.1.211:/var/root/ && ssh root@192.168.1.211