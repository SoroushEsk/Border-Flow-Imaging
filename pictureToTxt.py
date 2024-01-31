from PIL import Image, ImageFilter

# imagePath = input()

image = Image.open("Pic 1_64 Pix .jpg")
image = image.point(
    lambda x: 255 if x > 100 else 0)
pixelList = list(image.getdata())

pixelIndex = 0
toTxt = ""
for row in range(64):
    for col in range(64):
        if(pixelList[pixelIndex][0] == 255):
            toTxt += "0"
        else:
            toTxt += "1"
            print(row, col)
        pixelIndex += 1
    
    toTxt += "\n"
open("image1.txt", "w").write(toTxt)