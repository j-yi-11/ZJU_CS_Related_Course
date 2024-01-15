#pragma once

#include "defs.h"
#include "list.h"
#define SFS_MAX_INFO_LEN     32
#define SFS_MAGIC            0x1f2f3f4f
#define SFS_NDIRECT          11
#define SFS_DIRECTORY        1
#define SFS_MAX_FILENAME_LEN 27

//jy added
#define SFS_MAX_BLOCK_NUM 400
#define MAX_OPEN_FILES 16
#define SFS_BLOCK_SIZE 4096ULL
#define MIN(a,b) (((a)<(b))?(a):(b))
//


#define SEEK_CUR 0
#define SEEK_SET 1
#define SEEK_END 2

#define SFS_FILE 0
#define SFS_DIRECTORY 1

#define SFS_FLAG_READ 0
#define SFS_FLAG_WRITE 1

struct sfs_super {
    uint32_t magic;
    uint32_t blocks;
    uint32_t unused_blocks;
    char info[SFS_MAX_INFO_LEN + 1];
};

struct sfs_inode {
    uint32_t size;                 // 文件大小
    uint16_t type;                 // 文件类型，文件/目录
    uint16_t links;                // 硬链接数量
    uint32_t blocks;               // 本文件占用的 block 数量
    uint32_t direct[SFS_NDIRECT];  // 直接数据块的索引值
    uint32_t indirect;             // 间接索引块的索引值
};

struct sfs_entry {
    uint32_t ino;                            // 文件的 inode 编号
    char filename[SFS_MAX_FILENAME_LEN + 1]; // 文件名
};

/**
 * 功能: 初始化 simple file system
 * @ret : 成功初始化返回 0，否则返回非 0 值
 */
int sfs_init();


/**
 * 功能: 打开一个文件, 读权限下如果找不到文件，则返回一个小于 0 的值，表示出错，写权限如果没有找到文件，则创建该文件（包括缺失路径）
 * @path : 文件路径 (绝对路径)
 * @flags: 读写权限 (read, write, read | write)
 * @ret  : file descriptor (fd), 每个进程根据 fd 来唯一的定位到其一个打开的文件
 *         正常返回一个大于 0 的 fd 值, 其他情况表示出错
 */
int sfs_open(const char* path, uint32_t flags);


/**
 * 功能: 关闭一个文件，并将其修改过的内容写回磁盘
 * @fd  : 该进程打开的文件的 file descriptor (fd)
 * @ret : 正确关闭返回 0, 其他情况表示出错
 */
int sfs_close(int fd);


/**
 * 功能  : 根据 fromwhere + off 偏移量来移动文件指针(可参考 C 语言的 fseek 函数功能)
 * @fd  : 该进程打开的文件的 file descriptor (fd)
 * @off : 偏移量
 * @fromwhere : SEEK_SET(文件头), SEEK_CUR(当前), SEEK_END(文件尾)
 * @ret : 表示错误码
 *        = 0 正确返回
 *        < 0 出错
 */
int sfs_seek(int fd, int32_t off, int fromwhere);


/**
 * 功能  : 从文件的文件指针开始读取 len 个字节到 buf 数组中 (结合 sfs_seek 函数使用)，并移动对应的文件指针
 * @fd  : 该进程打开的文件的 file descriptor (fd)
 * @buf : 读取内容的缓存区
 * @len : 要读取的字节的数量
 * @ret : 返回实际读取的字节的个数
 *        < 0 表示出错
 *        = 0 表示已经到了文件末尾，没有能读取的了
 *        > 0 表示实际读取的字节的个数，比如 len = 8，但是文件只剩 5 个字节的情况，就是返回 5
 */
int sfs_read(int fd, char* buf, uint32_t len);


/**
 * 功能  : 把 buf 数组的前 len 个字节写入到文件的文件指针位置(覆盖)(结合 sfs_seek 函数使用)，并移动对应的文件指针
 * @fd  : 该进程打开的文件的 file descriptor (fd)
 * @buf : 写入内容的缓存区
 * @len : 要写入的字节的数量
 * @ret : 返回实际的字节的个数
 *        < 0 表示出错
 *        >=0 表示实际写入的字节数量
 */
int sfs_write(int fd, char* buf, uint32_t len);


/**
 * 功能    : 获取 path 下的所有文件名，并存储在 files 数组中
 * @path  : 文件夹路径 (绝对路径)
 * @files : 保存该文件夹下所有的文件名
 * @ret   : > 0 表示该文件夹下有多少文件
 *          = 0 表示该 path 是一个文件
 *          < 0 表示出错
 */
int sfs_get_files(const char* path, char* files[]);

// -------------------------------------------------------
// ------------ 以下数据结构和缓存设计可自行修改---------------

// 内存中的 block 缓存结构
struct sfs_memory_block {
    union {
        struct sfs_inode* din;   // 可能是 inode 块
        char *block;      // 可能是数据块
    } block;
    bool is_inode;        // 是否是 inode
    uint32_t blockno;     // block 编号
    bool dirty;           // 脏位，保证写回数据
    int reclaim_count;    // 指向次数，因为硬链接有可能会打开同一个 inode，所以需要记录次数
    struct list_head inode_link; // 在 sfs_fs 内 inode_list 链表中的位置 （可根据自己的数据结构设计自行修改）
};

typedef struct block{
    //data
    struct sfs_memory_block bufferBlock;
    // link
    struct list_head next_block_address;
}sfs_block;

typedef struct hash_node{
    // data
    int32_t inode_number;
    sfs_block *inode_block_address;
    // link
    struct hash_node *next;
}sfs_hash_node;

struct sfs_fs {
    struct sfs_super super;           // SFS 的超级块
    char *freemap;           // freemap 区域管理，可自行设计
    bool super_dirty;          // 超级块或 freemap 区域是否有修改
    sfs_block* block_list;   // 加载进来的 block 组织起来的链表 （数据结构可自行设计）
    sfs_hash_node *hash_list;   // Hash 表 （数据结构可自行设计）: inode number-->block address that contains inode
};