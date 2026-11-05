#!/bin/bash
echo "Start downloading PolyBench/C Test set..."
wget https://ghfast.top/https://github.com/MatthiasJReisinger/PolyBenchC-4.2.1/archive/refs/heads/master.zip -O polybench.zip

echo "Unzip the test set..."
sudo apt-get install -y unzip > /dev/null 2>&1
unzip -q polybench.zip

echo "Clean up the zip file and rename the folder..."
rm polybench.zip
mv PolyBenchC-4.2.1-master polybench

echo "PolyBench/C Downloaded and set up successfully！"
