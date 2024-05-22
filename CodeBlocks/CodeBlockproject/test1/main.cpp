#include<gl/glut.h>
#include<math.h>
#include<windows.h>
#include<vector>
#include<algorithm>
#include<iostream>
using namespace std;
#define N 2000

struct Point
{
    int x, y;
    Point() {};
    Point(int tx, int ty)
    {
        x = tx;
        y = ty;
    }
};
vector<Point> p;

double getW(double t, double a, double b, double c, double d)
{
    return a * pow(t, 3) + b * pow(t, 2) + c * t + d;
}

void Bezier()

{
    double derta = 1.0 / N;
    glPointSize(2);
    glColor3d(0, 0, 223);
    glBegin(GL_POINTS);
    for (int i = 1; i <= N; i++)
    {
        double t = derta * i;
        double r[4];
        r[0] = getW(t, -1, 3, -3, 1);
        r[1] = getW(t, 3, -6, 3, 0);
        r[2] = getW(t, -3, 3, 0, 0);
        r[3] = getW(t, 1, 0, 0, 0);
        double x = 0, y = 0;
        for (int j = 0; j < 4; j++)
        {
            x += r[j] * p[j].x;
            y += r[j] * p[j].y;
        }
        glVertex2d(x, y);
    }
    glEnd();
}
void myDisplay()
{
    float r[4] = { 0,0.4,0.6,1 };
    float g[4] = { 0.3,0.6,0.9,1 };
    float b[4] = { 0,0.4,0.8,0 };
    glClear(GL_COLOR_BUFFER_BIT);
    glPointSize(10);
    glBegin(GL_POINTS);
    for (int i = 0; i < p.size(); i++) {
        glColor3d(r[i], g[i], b[i]);
        glVertex2d(p[i].x, p[i].y);
    }
    glEnd();
    glLineWidth(2);
    glColor3d(0, 0, 0);
    glBegin(GL_LINE_STRIP);
    for (int m = 0; m < p.size(); m++)
        glVertex2d(p[m].x, p[m].y);
    glEnd();
    if (p.size() == 4)
        Bezier();
    glFlush();
}
void mouse(int button, int state, int x, int y)
{
    if (button == GLUT_LEFT_BUTTON && state == GLUT_DOWN && p.size() < 4)
    {
        Point t(x, y);
        p.push_back(t);
        glutPostRedisplay();
    }
}

void movingMouse(int x, int y) {
    int previousPoint ;
    if (p.empty()) {
        previousPoint= -1;
    }
    else {
        int previous = -1;
        double min = -1;
        for (int i = 0; i < p.size(); i++) {
            double dis = (p[i].x - x) * (p[i].x - x) + (p[i].y - y) * (p[i].y - y);
            if (min == -1 || min > dis) {
                min = dis;
                previous = i;
            }
        }
        previousPoint = previous;
    }
    if (previousPoint == -1) return;
    p[previousPoint].x = x;
    p[previousPoint].y = y;
    glutPostRedisplay();
}

void Reshape(int w, int h)
{
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0, w, h, 0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

void initWindow(int& argc, char* argv[], int width, int height, char* title)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition((GetSystemMetrics(SM_CXSCREEN) - width) >> 1, (GetSystemMetrics(SM_CYSCREEN) - height) >> 1);
    glutInitWindowSize(width, height);
    glutCreateWindow(title);
    glClearColor(1, 1, 1, 0);
    glShadeModel(GL_FLAT);
}

int main(int argc, char* argv[])
{
    initWindow(argc, argv, 600, 600, "三次Bezier曲线作图法");
    puts("\n\t用鼠标在窗口选择四个点来绘制三次Bezier曲线");
    glutDisplayFunc(myDisplay);
    glutReshapeFunc(Reshape);
    glutMouseFunc(mouse);
    glutMotionFunc(movingMouse);
    glutMainLoop();
    return 0;
}
