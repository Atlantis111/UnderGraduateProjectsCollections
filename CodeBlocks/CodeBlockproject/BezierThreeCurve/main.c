#include<stdlib.h>
#include<stdio.h>
#include<windows.h>
#include<math.h>
#include<GL/glut.h>

//定义控制点数目的最大值
#define MAX_CPTX 25
int ncpts=0;//实际控制点个数

static int width=500,height=500;//窗口大小

typedef struct
{
    GLfloat x,y;
} dot;

dot cpts[MAX_CPTX];//存储控制点坐标

int factorial(int n)
{
    if(n==1||n==0)
    {
        return 1;
    }
    else
    {
        return n*factorial(n-1);
    }
}
//求组合排列
double C_operation(int n,int i)
{
    return ((double)factorial(n))/((double)(factorial(i)*factorial(n-i)));
}
//求一个数u的num次方
double N_operation(double u,int n)
{
    double sum=1.0;
    if (n==0)
    {
        return 1;
    }
    for(int i=0; i<n; i++)
    {
        sum*=u;
    }
    return sum;
}

//绘制bezier曲线
void drawBezier(dot *p)
{
    void display();
    if(ncpts<=0)
        return;

    dot *p1;
    p1=(dot*)malloc(sizeof(dot)*1000);
    GLfloat u=0,x,y;

    int i,num=1;
    p1[0]=p[0];
    for(u=0; u<=1; u=u+0.001)
    {
        x=0;
        y=0;
        for(i=0; i<ncpts; i++)
        {
            x+=C_operation(ncpts-1,i)*N_operation(u,i)*N_operation((1-u),(ncpts-1-i))*p[i].x;
            y+=C_operation(ncpts-1,i)*N_operation(u,i)*N_operation((1-u),(ncpts-1-i))*p[i].y;
        }
        p1[num].x=x;
        p1[num].y=y;
        num++;
    }

    glPointSize(4.0);
    glColor3f(0.0,2.0,0.0);
    glBegin(GL_LINE_STRIP);
    for(int k=0; k<1000; k++)
    {
        glVertex2f(p1[k].x,p1[k].y);
    }
    glEnd();
    glFlush();
    return;
}


//输入新的控制点
static void mouse(int button, int state,int x,int y)
{
    void display();
    float wx,wy;
    if(state!=GLUT_DOWN)
        return;
    else
    {
        if(button==GLUT_LEFT_BUTTON)
        {
        //坐标转换
            wx=(2.0*x)/(float)(width-1)-1.0;
            wy=(2.0*(height-1-y))/(float)(height-1)-1.0;
            if(ncpts==MAX_CPTX)
                return;

        //存储点
            cpts[ncpts].x=wx;
            cpts[ncpts].y=wy;
            ncpts++;

        //绘制点
            glPointSize(5.0);
            glBegin(GL_POINTS);
            glVertex2f(wx,wy);
            glEnd();
            glFlush();
        }
        if(button==GLUT_RIGHT_BUTTON)
        {
            display();
            drawBezier(cpts);
        }
    }
}

//展示图像
void display(void)
{
    int i;
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1.0,0.0,0.0);
    glPointSize(10.0);
    glBegin(GL_POINTS);
    for (i = 0; i < ncpts; i++)
        glVertex2f(cpts[i].x,cpts[i].y);
    glEnd();
    glFlush();

}

//键盘回调
void keyboard(unsigned char key,int x,int y)
{
    switch (key)
    {
    case 'q':
    case 'Q':
        exit(0);
        break;
    case 'c':
    case 'C':
        ncpts = 0;
        glutPostRedisplay();
        break;
    case 'r':
    case 'R':
        ncpts--;
        glutPostRedisplay();
        break;
    }
}


void reshape(int w,int h)
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-1.0,1.0,-1.0,1.0,-1.0,1.0);
    glMatrixMode(GL_MODELVIEW);
    glViewport(0,0,w,h);
    width=w;
    height=h;
}

int main(int argc, char **argv)
{
    //构造窗口
    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_RGB);
    glutInitWindowSize(width,height);
    glutCreateWindow("TEST");

    //绘制图像
    glutDisplayFunc(display);
    glutMouseFunc(mouse);
    glutKeyboardFunc(keyboard);
    glutReshapeFunc(reshape);
    glClearColor(0.0,0.0,0.0,0.0);
    glColor3f(0.0,0.0,0.0);
    glutMainLoop();
}

