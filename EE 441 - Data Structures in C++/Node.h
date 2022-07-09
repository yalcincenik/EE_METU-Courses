#ifndef NODE_H_INCLUDED
#define NODE_H_INCLUDED

#pragma once

#include <stdio.h>
#include <iostream>

class Node
{
private:
  int mProcessID;
  int mArrivalTime;
  int mRunTime;
  int mPriority;

  // set all pointer as null initally
  Node* next = NULL;
  Node* left = NULL;
  Node* right = NULL;

public:
  // 2 Constructors
  Node();
  Node(int processID, int arrivalTime, int runTime, int priority);

  // Getters

  int getProcessID();
  int getArrivalTime();
  int getRunTime();
  int getPriority();

  Node* getNext();
  Node* getLeft();
  Node* getRight();

  // Setters
  void setRunTime(int runTime);
  void setRight(Node* node);
  void setLeft(Node* node);
  void setNext(Node* node);
  void printNode();
};

#endif // NODE_H_INCLUDED
