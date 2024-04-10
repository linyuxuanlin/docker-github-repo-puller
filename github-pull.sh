#!/bin/bash

path="$PROJECTS_PATH"
github_token="$GITHUB_TOKEN"
github_username="$GITHUB_USERNAME"

# 如果 HTTP_PROXY 和 HTTPS_PROXY 环境变量已设置，则配置 git 代理
if [ -n "$HTTP_PROXY" ] && [ -n "$HTTPS_PROXY" ]; then
    git config --global http.proxy "$HTTP_PROXY"
    git config --global https.proxy "$HTTPS_PROXY"
fi

# 搜索并遍历所有 Git 仓库
for dir in $(find "$path" -maxdepth 2 -type d -name '.git' | sed 's/.git$//'); do

    # go into the directory and perform a git pull
    cd "$dir"
    echo "Pulling $dir"
    
    # 添加仓库所有权
    git config --global --add safe.directory '*' 
    
    # 剪切路径中的仓库名，方便设置仓库 url
    dirname="$(basename "$dir")"
    #echo "$dirname"
    # 设置仓库 url，需要先在 GitHub 申请 token
    git remote set-url origin "https://$github_token@github.com/$github_username/$dirname.git"
    
    git pull
done

# 如果设置了 git 代理，则重置 git 代理
if [ -n "$HTTP_PROXY" ] && [ -n "$HTTPS_PROXY" ]; then
    git config --global --unset http.proxy
    git config --global --unset https.proxy
fi
