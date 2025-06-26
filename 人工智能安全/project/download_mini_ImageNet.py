import requests
import os
def download_file(url, local_filename):
    # 发送一个HTTP请求到URL
    response = requests.get(url)

    # 确保请求成功
    if response.status_code == 200:
        # 打开本地文件，准备写入数据
        with open(local_filename, 'wb') as f:
            # 写入响应的内容
            f.write(response.content)
    else:
        print(f"Failed to download file. HTTP Status Code: {response.status_code}")

if __name__ == "__main__":
    print("current working directory: ", os.getcwd())
    # 下载mini-ImageNet数据集
    download_file("https://www.dropbox.com/s/3v7v9l8yj2w6lwt/mini-imagenet.zip?dl=1", "mini-imagenet.zip")
    print("Downloaded mini-ImageNet dataset")