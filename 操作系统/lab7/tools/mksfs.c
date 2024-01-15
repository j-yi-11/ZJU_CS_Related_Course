#include <stdio.h>
#include <string.h>

typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

#define SFS_MAX_INFO_LEN     32
#define SFS_MAGIC            0x1f2f3f4f
#define SFS_NDIRECT          11
#define SFS_DIRECTORY        1
#define SFS_MAX_FILENAME_LEN 27

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

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: mksfs sfs.img\n");
        return -1;
    }
    
    struct sfs_super super_block;
    super_block.magic         = SFS_MAGIC;
    super_block.blocks        = 4096;
    super_block.unused_blocks = 4096 - 4;
    strcpy(super_block.info, "Hello My Simple File System!");

    struct sfs_inode root_inode;
    root_inode.size      = sizeof(struct sfs_entry);
    root_inode.type      = SFS_DIRECTORY;
    root_inode.links     = 1;
    root_inode.blocks    = 1;
    root_inode.direct[0] = 3;
    root_inode.indirect  = 0;

    char freemap[4096];
    memset(freemap, 0, sizeof(freemap));
    freemap[0] = 0b00001111;
    
    struct sfs_entry entry;
    entry.ino = 1;
    strcpy(entry.filename, ".");
    
    FILE *fp = fopen(argv[1], "rb+");
    if (fp == NULL) {
        printf("%s not found!\n", argv[1]);
        return -1;
    }

    fseek(fp, 0, SEEK_SET);
    fwrite((char *)&super_block, sizeof(char), sizeof(super_block), fp);

    fseek(fp, 4096, SEEK_SET);
    fwrite((char *)&root_inode, sizeof(char), sizeof(root_inode), fp);

    fseek(fp, 4096 * 2, SEEK_SET);
    fwrite((char *)&freemap, sizeof(char), sizeof(freemap), fp);

    fseek(fp, 4096 * 3, SEEK_SET);
    fwrite((char *)&entry, sizeof(char), sizeof(entry), fp);
    
    fclose(fp);
    return 0;
}