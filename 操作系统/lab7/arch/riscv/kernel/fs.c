#include "fs.h"
#include "buf.h"
#include "defs.h"
#include "slub.h"
#include "task_manager.h"
#include "virtio.h"
#include "vm.h"
#include "mm.h"

// --------------------------------------------------
// ----------- read and write interface -------------

void disk_op(int blockno, uint8_t *data, bool write) {
    struct buf b;
    b.disk = 0;
    b.blockno = blockno;
    b.data = (uint8_t *)PHYSICAL_ADDR(data);
    virtio_disk_rw((struct buf *)(PHYSICAL_ADDR(&b)), write);
}

#define disk_read(blockno, data) disk_op((blockno), (data), 0)
#define disk_write(blockno, data) disk_op((blockno), (data), 1)

// -------------------------------------------------
// ------------------ your code --------------------

// 文件系统初始化标志
static int fs_initialized = 0;
// 全局变量，用于存储文件系统信息
struct sfs_fs sfs;  


// struct sfs_super {
//     uint32_t magic;
//     uint32_t blocks;
//     uint32_t unused_blocks;
//     char info[SFS_MAX_INFO_LEN + 1];
// };

// struct sfs_inode {
//     uint32_t size;                 // 文件大小
//     uint16_t type;                 // 文件类型，文件/目录
//     uint16_t links;                // 硬链接数量
//     uint32_t blocks;               // 本文件占用的 block 数量
//     uint32_t direct[SFS_NDIRECT];  // 直接数据块的索引值
//     uint32_t indirect;             // 间接索引块的索引值
// };

// struct sfs_entry {
//     uint32_t ino;                            // 文件的 inode 编号
//     char filename[SFS_MAX_FILENAME_LEN + 1]; // 文件名
// };


int sfs_init()
{
    if(fs_initialized==0){
        // 1. 分配并初始化文件系统结构 sfs_fs
        memset(&sfs, 0, sizeof(struct sfs_fs));
        // 2. 超级块信息
        char block_content[4096];
        memset(block_content, 0, sizeof(block_content));
        disk_read(0, block_content);
        sfs.super = (sfs_super*)block_content;
        // 3. 初始化root inode
        memset(block_content, 0, sizeof(block_content));
        disk_read(1, block_content);
        sfs.inode_list = (sfs_inode*)block_content;// TODO use list_add
        // 4. 分配并初始化空闲块位图，使用 sfs.freemap
        memset(block_content, 0, sizeof(block_content));
        disk_read(2, block_content);
        strncpy(sfs.freemap, block_content, sizeof(block_content));
        // a lot of TODO 
        // 5. 文件名是 "." 的 inode
        memset(block_content, 0, sizeof(block_content));
        disk_read(3, block_content);
        sfs.inode_list = (sfs_entry *)block_content;// TODO use list_add
        // 6. 初始化其他必要的数据结构
        // 可根据需要初始化 inode_list、hash_list 等
        fs_initialized = 1;
    }else{
        return 0;
    }
}

// struct file {
//   struct sfs_inode * inode;
//   struct sfs_inode * path;
//   uint64_t flags;
//   uint64_t off;
//   // 可以增加额外数据来辅助你的缓存管理
// };

// struct files_struct {
//   struct file * fds[16];  // 一个进程最多可以同时打开 16 个文件
// };


int sfs_open(const char *path, uint32_t flags)
{
    // 初始化文件系统
    fs_init();
    if(flags && SFS_FLAG_READ){

    }
    if(flags && SFS_FLAG_WRITE){
        
    }
    // 解析文件路径，获取文件的 inode
    struct sfs_inode inode;
    // int ret = sfs_lookup(path, &inode);
    // if (ret < 0) {
    //     // 文件不存在或发生其他错误
    //     return -1;
    // }

    // 根据 flags 打开文件，创建文件描述符
    struct file *file = kmalloc(sizeof(struct file));
    if (file == NULL) {
        // 内存分配失败
        return -1;
    }

    file->inode = &inode;
    file->flags = flags;
    file->off = 0;

    // 将文件描述符存储到进程的文件描述符数组中
    // 这里简化处理，实际需要根据具体情况处理文件描述符数组的管理
    struct files_struct *current_files = &current->fs;
    int fd;
    for (fd = 0; fd < 16; fd++) {
        if (current_files->fds[fd] == NULL) {
            current_files->fds[fd] = file;
            break;
        }
    }

    if (fd == 16) {
        // 文件描述符数组已满
        kfree(file);
        return -1;
    }

    // 返回文件描述符号
    return fd;
}

int sfs_close(int fd)
{
    // 假设有一个全局的文件系统结构体
    extern struct sfs_fs sfs;

    // 检查文件描述符是否有效
    if (fd < 0 || fd >= MAX_OPEN_FILES) {
        return -1;  // 无效的文件描述符
    }

    // 获取文件描述符对应的文件结构
    struct file* file_entry = current->fs.fds[fd];
    if (file_entry == NULL) {
        return -1;  // 文件结构为空，表示文件未打开或已关闭
    }

    // TODO: 在这里进行相应的关闭文件操作
    // 1. 将文件的内容写回磁盘（如果有修改的话）
    // 2. 释放相应的资源，例如内存缓存
    // 3. 清除文件描述符表中的条目

    // 释放文件结构
    kfree(file_entry);

    // 清除文件描述符表中的条目
    current->fs.fds[fd] = NULL;

    return 0;  // 返回 0 表示正确关闭
}

int sfs_seek(int fd, int32_t off, int fromwhere)
{
        // 假设有一个全局的文件系统结构体
    extern struct sfs_fs sfs;

    // 检查文件描述符是否有效
    if (fd < 0 || fd >= MAX_OPEN_FILES) {
        return -1;  // 无效的文件描述符
    }

    // 获取文件描述符对应的文件结构
    struct file* file_entry = current->fs.fds[fd];
    if (file_entry == NULL) {
        return -1;  // 文件结构为空，表示文件未打开或已关闭
    }

    // 根据 fromwhere 类型计算新的文件指针位置
    switch (fromwhere) {
        case SEEK_SET:
            file_entry->off = off;
            break;
        case SEEK_CUR:
            file_entry->off += off;
            break;
        case SEEK_END:
            file_entry->off = (*(file_entry->inode)).size + off;
            break;
        default:
            return -1;  // 无效的 fromwhere 类型
    }

    // TODO: 在这里进行相应的处理，例如检查新的文件指针位置是否合法

    return 0;  // 返回 0 表示正确移动文件指针
}

int sfs_read(int fd, char *buf, uint32_t len)
{
    // 假设有一个全局的文件系统结构体
    extern struct sfs_fs sfs;
    // 检查文件描述符是否有效
    if (fd < 0 || fd >= MAX_OPEN_FILES) {
        return -1;  // 无效的文件描述符
    }
    // 获取文件描述符对应的文件结构
    struct file* file_entry = current->fs.fds[fd];
    if (file_entry == NULL) {
        return -1;  // 文件结构为空，表示文件未打开或已关闭
    }

    // 读取文件内容到缓冲区 buf
    uint32_t remaining_len = len;
    while (remaining_len > 0) {
        // 计算当前读取的块号
        uint32_t block_no = file_entry->off / SFS_BLOCK_SIZE;
        // 计算当前块内的偏移量
        uint32_t block_offset = file_entry->off % SFS_BLOCK_SIZE;
        // 计算剩余可读取的字节数
        uint32_t bytes_to_read = MIN(SFS_BLOCK_SIZE - block_offset, remaining_len);

        // 读取文件内容
        if (block_no < SFS_NDIRECT) {
            // 直接索引块
            disk_read(block_no, buf);
        } else {
            // 间接索引块
            uint32_t indirect_block[SFS_BLOCK_SIZE / sizeof(uint32_t)];
            disk_read(file_entry->inode.indirect, (char*)indirect_block);
            disk_read((block_no - SFS_NDIRECT), buf);
        }

        // 更新文件指针位置和缓冲区
        file_entry->off += bytes_to_read;
        remaining_len -= bytes_to_read;
        buf += bytes_to_read;
    }

    return len - remaining_len;  // 返回实际读取的字节数
}

int sfs_write(int fd, char *buf, uint32_t len)
{
    // 假设有一个全局的文件系统结构体
    extern struct sfs_fs sfs;

    // 检查文件描述符是否有效
    if (fd < 0 || fd >= MAX_OPEN_FILES) {
        return -1;  // 无效的文件描述符
    }

    // 获取文件描述符对应的文件结构
    struct file* file_entry = current->fs.fds[fd];
    if (file_entry == NULL) {
        return -1;  // 文件结构为空，表示文件未打开或已关闭
    }

    // 写入文件内容
    uint32_t remaining_len = len;
    while (remaining_len > 0) {
        // 计算当前写入的块号
        uint32_t block_no = file_entry->off / SFS_BLOCK_SIZE;
        // 计算当前块内的偏移量
        uint32_t block_offset = file_entry->off % SFS_BLOCK_SIZE;
        // 计算剩余可写入的字节数
        uint32_t bytes_to_write = MIN(SFS_BLOCK_SIZE - block_offset, remaining_len);

        // 写入文件内容
        if (block_no < SFS_NDIRECT) {
            // 直接索引块
            disk_write(block_no, buf);
        } else {
            // 间接索引块
            uint32_t indirect_block[SFS_BLOCK_SIZE / sizeof(uint32_t)];
            if (file_entry->inode.indirect == 0) {
                // 间接索引块不存在，需要创建
                // TODO: 创建间接索引块
            }
            disk_read(file_entry->inode.indirect, (char*)indirect_block);
            disk_write(indirect_block[block_no - SFS_NDIRECT], buf);
            disk_write(file_entry->inode.indirect, (char*)indirect_block);
        }

        // 更新文件指针位置和缓冲区
        file_entry->off += bytes_to_write;
        remaining_len -= bytes_to_write;
        buf += bytes_to_write;
    }

    return len - remaining_len;  // 返回实际写入的字节数
}

int sfs_get_files(const char* path, char* files[])
{
    // 假设有一个全局的文件系统结构体
    extern struct sfs_fs sfs;

    // 查找文件夹的 inode
    struct sfs_inode dir_inode;
    sfs_lookup(path, &dir_inode);

    // 判断是否是文件夹
    if (dir_inode.type != SFS_DIRECTORY) {
        return 0;  // 不是文件夹
    }

    // 读取文件夹的目录项
    char dir_buf[SFS_BLOCK_SIZE];
    for (int i = 0; i < SFS_NDIRECT; ++i) {
        disk_read(dir_inode.direct[i], dir_buf);
        // 遍历目录项
        struct sfs_entry* entry = (struct sfs_entry*)dir_buf;
        for (int j = 0; j < SFS_ENTRY_PER_BLOCK; ++j) {
            if (entry[j].ino != 0) {
                // 将文件名复制到 files 数组中
                strcpy(files[j], entry[j].filename);
            }
        }
    }

    // TODO: 处理间接索引块的目录项

    return 0;  // 返回文件夹下的文件数 TODO
}