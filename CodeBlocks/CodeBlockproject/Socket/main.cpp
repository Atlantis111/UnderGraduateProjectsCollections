#include<WinSock2.h>
#include<Windows.h>
#include<process.h>
#include<iostream>

#pragma comment (lib, "ws2_32.lib")

using namespace std;

typedef struct complex
{
    SOCKET ClientSocket;
    sockaddr_in clntAddr;
    int id;
}complex;

DWORD WINAPI thread(const LPVOID param)//子线程执行函数
{
    complex* temp = (complex*)param;
    int my_id = temp->id;
    cout << my_id << "等待客户端发送数据。 id地址：" << &(temp->id) << endl;

    char szBuffer[MAXBYTE] = { 0 };
    recv(temp->ClientSocket, szBuffer, MAXBYTE, NULL);
    cout << my_id << "从客户端接受到:" << szBuffer << " id:" << temp->id << endl;

    //向客户端发送数据
    char* str = "服务器";
    send(temp->ClientSocket, str, strlen(str) + sizeof(char), NULL);
    cout << my_id << "成功向客户端发送数据" << " id:" << temp->id  << endl;

    return 0;
}

int main()
{
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET servSock = socket(PF_INET, SOCK_STREAM, 0);
    sockaddr_in sockAddr;
    memset(&sockAddr, 0, sizeof(sockAddr));
    sockAddr.sin_family = PF_INET;
    sockAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    sockAddr.sin_port = htons(1234);
    bind(servSock, (SOCKADDR*)&sockAddr, sizeof(SOCKADDR));

    HANDLE hThread[2];
    listen(servSock, 20);
    for (int i = 0; i < 2; i++)
    {
        complex* temp = new complex;
        sockaddr_in clntAddr;
        int nSize = sizeof(SOCKADDR);
        SOCKET clntSock = accept(servSock, (SOCKADDR*)&clntAddr, &nSize);

        temp->ClientSocket = clntSock;
        temp->id = i + 1;
        temp->clntAddr = clntAddr;
        cout << temp << endl;
        hThread[i] = CreateThread(NULL, 0, &thread, temp, 0, NULL);
    }
    WaitForMultipleObjects(2, hThread, TRUE, INFINITE);
    system("pause");
    WSACleanup();
    return 0;
}
