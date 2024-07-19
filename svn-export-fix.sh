if [ $# -ne 5 ]; then
  echo "Usage: `basename $0` [github_user] [github_repo] [branch] [repo_dir] [dest_dir]"
  exit 0
fi

DEST_DIR=$5
SOURCE_URL=https://github.com/$1/$2/archive/refs/heads/$3.tar.gz
SOURCE_DIR=$2-$3/$4

curl -sILf $SOURCE_URL | grep "^content-type: application/x-gzip" 1>/dev/null

if [ $? -ne 0 ]; then
  echo "GitHub repo '$1/$2' does not exist or does not have the '$3' branch"
  exit 1
fi

rm -rf $DEST_DIR/* 2>/dev/null
mkdir -p $DEST_DIR/.temp
curl -sL $SOURCE_URL | tar -xf - --directory=$DEST_DIR/.temp $SOURCE_DIR
mv $DEST_DIR/.temp/$SOURCE_DIR/* $DEST_DIR
rm -r $DEST_DIR/.temp