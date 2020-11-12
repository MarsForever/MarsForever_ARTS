##### Get the code for the course

go get -u -d github.com/inancgumus/learngo

##### GOPATH
go env GOPATH
cd $( go env GOPATH)

* mac / Linux: ~/go
* %userprofile%go ?  c:/Go/workspace

##### $GOPATH/workspace

* for go projects

* Go tools find Go source-code files

##### $GOPATH/src

* source-code files

expample

$GOPATH/src/first/main.go

##### open src file with vs code

code $(go env GOPATH)