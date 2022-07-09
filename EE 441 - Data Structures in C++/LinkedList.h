#ifndef LINKEDLIST_H_INCLUDED
#define LINKEDLIST_H_INCLUDED

#pragma once

#include <stdio.h>
#include <iostream>

#include "Node.h"

class LinkedList {

private:
    Node* head;
    Node* tail;
    int visitedNodesInsert;
    int visitedNodesDelete;
    int visitedNodesSearch;

public:
    // Constructor
    LinkedList();
    // Getters
    int getvisitedNodesInsert();
    int getvisitedNodesDelete();
    int getvisitedNodesSearch();
    Node* getNode();

    // Insertion and Deletion

    void insertNode(Node* node);
    void deleteNode(Node* node);

    // Check list
    bool listEmpty();

};
/* Ýmplemenations based on the the websites
/ [1] https://cplusplus.happycodings.com/data-structures-and-algorithm-analysis-in-cplusplus/code28.html
  [2] https://medium.com/@terselich/create-you-own-linked-list-in-c-8deb653273 */


#endif // LINKEDLIST_H_INCLUDED
