#include "Node.h"
#include "LinkedList.h"
#include "Tree.h"
#include <iostream>
#include <iomanip>
#include <vector>
#include <chrono>
#include <fstream>

/* EE 441 HOMEWORK 3- OPERATING SYSTEM SCHEDULING WITH LINKED LIST AND TREE */

// To be able to implement both Tree and Linked List, Node Class is constructed

// Constructor 1 Setting

Node::Node()
{
  mProcessID = 0;
  mArrivalTime = 0;
  mRunTime = 0;
  mPriority = 0;
}

// Constructor 2 Setting

Node::Node(int processID, int arrivalTime, int runTime, int priority)
{
  mProcessID = processID;
  mArrivalTime = arrivalTime;
  mRunTime = runTime;
  mPriority = priority;
}
/* SETTERS OF THE NODE CLASS
    - Set Next
    - Set Right
    - Set Left
    - Set the corresponding Running Time
*/

void Node::setNext(Node * node)
{
  next = node;
}

void Node::setRight(Node * node)
{
  right = node;
}

void Node::setLeft(Node * node)
{
  left = node;
}

void Node::setRunTime(int runTime)
{
  mRunTime = runTime;
}

void Node::printNode()
{
  std::cout << mProcessID << std::endl;
}
// ---------------------- GETTERS OF THE NODE CLASS ----------------------------

// Get the Process ID

int Node::getProcessID()
{
  return mProcessID;
}

// Get the Arrival Time

int Node::getArrivalTime()
{
  return mArrivalTime;
}

// Get the Corresponding Running Time

int Node::getRunTime()
{
  return mRunTime;
}

// Get Priority for new process

int Node::getPriority()
{
  return mPriority;
}

Node * Node::getLeft()
{
  return left;
}

Node * Node::getRight()
{
  return right;
}

Node * Node::getNext()
{
  return next;
}
//---------------------- GETTERS FINISHES HERE ------------------------------------------------

// Constructor Setting

LinkedList::LinkedList()
{
  visitedNodesInsert = 0;
  visitedNodesSearch = 0;
  visitedNodesDelete = 0;
  // Set head & tail pointers as NULL
  head = NULL;
  tail = NULL;
}

// Check the current state of the Linked List
// If the Head pointer of the linked list empty return true, otherwise false

bool LinkedList::listEmpty()
{
  if (head == NULL)
    return true;
  else
    return false;
}
// Insertion new Node

// REFERENCES For InsertNode(Node* node)
// [1] https://www.codesdope.com/blog/article/inserting-a-new-node-to-a-linked-list-in-c/
// ------------------------------ INSERTION NODE STARTS HERE ------------------------------------
void LinkedList::insertNode(Node * node)
{
  Node* tempNode;

  // Check whether the list empty or not
  if (head == NULL)
  {
    head = node;
    tail = node;
    visitedNodesInsert++;
  }
  else
  {
    // if head == tail, i.e only one node exists in the list
    if (head == tail)
    {
      if (node->getPriority() < head->getPriority())
      {
        visitedNodesInsert++;
        node->setNext(tail);
        head = node;
      }
      else
      {
        visitedNodesInsert = visitedNodesInsert + 2;
        tail = node;
        head->setNext(tail);
      }
    }
    else if (head->getPriority() > node->getPriority())
    {
      node->setNext(head);
      head = node;
      visitedNodesInsert++;
    }
    else
    {
      tempNode = head;

      while (true)
      {
        if (tempNode == tail)
        {
          tempNode->setNext(node);
          tail = node;
          visitedNodesInsert++;
          break;
        }
        else if (node->getPriority() < tempNode->getNext()->getPriority())
        {
          node->setNext(tempNode->getNext());
          tempNode->setNext(node);
          visitedNodesInsert++;
          break;
        }
        else
        {
          visitedNodesInsert++;
          tempNode = tempNode->getNext();
        }
      }
    }
  }
}
//------------------------- INSERTION NODE ENDS HERE -----------------------------------------

// REFERENCES for deleteNode(Node *node)
// [1] EE 441 Lecture Notes, CENG 213 LECTURE NOTES


void LinkedList::deleteNode(Node * node)
{
  // If list already empty, return NULL
  if (head == NULL)
    return;

  // IF list has only one element
  if (head == tail)
  {
    head = NULL;
    tail = NULL;
    visitedNodesDelete++;
    return;
  }
  // More than one element
  else
  {
    visitedNodesDelete++;
    head = head->getNext();
  }
}

// GETTERS

Node* LinkedList::getNode()
{
  visitedNodesSearch++;
  return head;
}

// Get the number of visited nodes insertion

int LinkedList::getvisitedNodesInsert()
{
  return visitedNodesInsert;
}

// Get the number of visited nodes for search

int LinkedList::getvisitedNodesSearch()
{
  return visitedNodesSearch;
}

// Get the number of Visited nodes for delete

int LinkedList::getvisitedNodesDelete()
{
  return visitedNodesDelete;
}

// REFERENCES
/* [1] https://www.geeksforgeeks.org/binary-search-tree-set-1-search-and-insertion/
   [2] http://www.hamedkiani.com/coding-interview/a-class-implementation-of-binary-search-tree-in-c
*/

// Constructor

Tree::Tree()
{
  visitedNodesInsert = 0;
  visitedNodesDelete = 0;
  visitedNodesSearch = 0;

  root = NULL; // Initally rooted node is NULL
}

// Check the current state of the Linked List

bool Tree::treeEmpty()
{
  if (root == NULL)
    return true;
  else
    return false;
}

// INSERT a node to the Tree according to the "Priority" of the node

/* ***************INSERTION NEW NODE STARTS HERE*************************
REFERENCES
[1] : https://www.log2base2.com/data-structures/tree/insert-a-node-in-binary-search-tree.html */

void Tree::insertNode(Node * node)
{
  Node* prev = NULL;
  Node* temp = root;

  if (root == NULL)
  {
    root = node;
    visitedNodesInsert++;
    return;
  }

  while (temp != NULL)
  {
    if (temp->getPriority() > node->getPriority())
    {
      prev = temp;
      temp = temp->getLeft();
      visitedNodesInsert++;
    }
    else if (temp->getPriority() < node->getPriority())
    {
      prev = temp;
      temp = temp->getRight();
      visitedNodesInsert++;
    }
  }

  if (prev->getPriority() > node->getPriority())
    prev->setLeft(node);
  else
    prev->setRight(node);
}

//---------------------- INSERTION ENDS HERE -------------------------------

// GETTER IMPLEMENTATIONS of the TREE

int Tree::getvisitedNodesInsert()
{
  return visitedNodesInsert;
}

int Tree::getvisitedNodesSearch()
{
  return visitedNodesSearch;
}

int Tree::getvisitedNodesDelete()
{
  return visitedNodesDelete;
}

Node * Tree::getNode()
{
  Node* temp = root;
  Node* prev = NULL;

  if (temp->getLeft() == NULL)
  {
    visitedNodesSearch++;
    return temp;
  }
  while (temp != NULL)
  {
    if (temp != NULL)
    {
      prev = temp;
      temp = temp->getLeft();
      visitedNodesSearch++;
    }

    else
    {
      prev = temp;
      temp = temp->getRight();
      visitedNodesSearch++;
    }
  }

  return prev;
}


// DELETION NODE FROM THE TREE

/* *************************** DELETION NODE STARTS HERE *****************************

REFERENCES : [1] explains everthing.
[1] : https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/https://www.geeksforgeeks.org/binary-search-tree-set-2-delete/
[2] : https://www.geeksforgeeks.org/deletion-binary-tree/ */

void Tree::deleteNode(Node * node)
{
  Node* temp = root;
  Node* prev = NULL;
  bool left = false;

  if (temp->getLeft() == NULL)
  {
    root = temp->getRight();
    visitedNodesDelete++;
  }
  else
  {
    while ((temp != NULL) && (temp->getPriority() != node->getPriority()))
    {
      prev = temp;
      if (node->getPriority() < temp->getPriority())
      {
        temp = temp->getLeft();
        left = true;
        visitedNodesDelete++;
      }
      else
      {
        temp = temp->getRight();
        left = false;
        visitedNodesDelete++;
      }
    }

    if (temp->getLeft() == NULL || temp->getRight() == NULL)
    {
      // New node for deleted node as a pointer
      Node* newDel;
      // If the left child of the node is empty
      if (temp->getLeft() == NULL)
        newDel = temp->getRight();
      else
        newDel = temp->getLeft();
      if (left)
        prev->setLeft(newDel);
      else
        prev->setRight(newDel);
    }
  }
}
using namespace std;
using namespace std::chrono;
using Clock = std::chrono::steady_clock;

/* IMPLEMENTATIONS BASED ON THE HOMEWORK DESCRIPTION
    CODE 1 and CODE 2 are used as the SAME parameter name as in the homework descriptipn */


void processSchedulerTree(Node** processList, int numProcesses)
{
  Tree tree;
  int time = 0;                     // CPU time
  bool CPUBusy = false;             // is the CPU currently running a process
  Node* currentProcess = nullptr;   // pointer to the process CPU is currently running
  int processIndex = 0;             // index of the process awaiting insertion in RQ

  /* SmpleOutputN_X.txt file is the expected output for the input processesN.txt using X
data structure for RQ (X=linked list, binary search tree) */

  std::ofstream outputtxt;
  std::string fileName = "";
  fileName += "sampleOutput";
  fileName += std::to_string(numProcesses);
  fileName += "_BinarySearchTree.txt";
  outputtxt.open(fileName);

  outputtxt << "Binary Search Tree RQ implementation" << std::endl << std::endl;

  auto start = Clock::now(); // clock start

  while ((processIndex < numProcesses) || (tree.treeEmpty() == false) || (CPUBusy == true))
  {

    if (processIndex < numProcesses) // there are processes not inserted into RQ
    {
      if (processList[processIndex]->getArrivalTime() == time) // if the process arrived now
      {
        tree.insertNode(processList[processIndex]);     // insert it into RQ
        processIndex = processIndex + 1;                // next process awaits insertion
      }
    }

    if (CPUBusy == true) // CPU is running a process
    {
      int tempRunTime = currentProcess->getRunTime();
      tempRunTime--;
      currentProcess->setRunTime(tempRunTime);
    }

    // 1 clock cycle elapsed
    if ((currentProcess != nullptr) && (currentProcess->getRunTime() == 0)) // if it was last cycle of the process
    {
      currentProcess->printNode();  // process finished execution
      outputtxt << currentProcess->getProcessID() << std::endl;
      CPUBusy = false;              // CPU is no longer running a process
    }

    if (CPUBusy == false && ((tree.treeEmpty() == false)))
    {
      // CPU is not running a process but there are processes awaiting execution
      currentProcess = tree.getNode();
      tree.deleteNode(currentProcess);
      CPUBusy = true; // CPU is now running a process
    }

    time = time + 1; // 1 clock cycle elapsed
  }

  auto stop = Clock::now();  // clock stop

  cout << std::endl;
  outputtxt << std::endl;
  cout << tree.getvisitedNodesInsert() << " nodes visited for insertion" << std::endl;
  outputtxt << tree.getvisitedNodesInsert() << " nodes visited for insertion" << std::endl;
  cout << tree.getvisitedNodesSearch() << " nodes visited for searching" << std::endl;
  outputtxt << tree.getvisitedNodesSearch() << " nodes visited for searching" << std::endl;
  cout << tree.getvisitedNodesDelete() << " nodes visited for deleting" << std::endl;
  outputtxt << tree.getvisitedNodesDelete() << " nodes visited for deleting" << std::endl;

  outputtxt.close();
}

// Process Scheduler with Linked List

void processSchedulerLinkedList(Node** processList, int numProcesses)
{
  LinkedList list;
  int time = 0;                     // CPU time
  bool CPUBusy = false;             // is the CPU currently running a process
  Node* currentProcess = nullptr;   // pointer to the process CPU is currently running
  int processIndex = 0;             // index of the process awaiting insertion in RQ
  int initialRunTime = 0;

  std::ofstream outputtxt;
  std::string fileName = "";
  fileName += "sampleOutput";
  fileName += std::to_string(numProcesses);
  fileName += "_LinkedList.txt";
  outputtxt.open(fileName);

  outputtxt << "Linked List RQ implementation" << std::endl << std::endl;

  auto start = Clock::now(); // clock start

  while((processIndex < numProcesses) || (list.listEmpty() == false) || (CPUBusy == true))
  {
    if (processIndex < numProcesses) // there are processes not inserted into RQ
    {
      if (processList[processIndex]->getArrivalTime() == time) // if the process arrived now
      {
        list.insertNode(processList[processIndex]);     // insert it into RQ
        processIndex = processIndex + 1;                // next process awaits insertion
      }
    }

    if (CPUBusy == true) // CPU is running a process
    {
      int tempRunTime = currentProcess->getRunTime();
      tempRunTime--;
      currentProcess->setRunTime(tempRunTime);
    }

    // 1 clock cycle elapsed
    if ((currentProcess != nullptr) && (currentProcess->getRunTime() == 0)) // if it was last cycle of the process
    {
      currentProcess->printNode();  // process finished execution
      outputtxt << currentProcess->getProcessID() << std::endl;
      currentProcess->setRunTime(initialRunTime); // restore to initial runTime value in order to use for Binary Search Tree
      CPUBusy = false;              // CPU is no longer running a process
    }

    if (CPUBusy == false && ((list.listEmpty() == false)))
    {
      // CPU is not running a process but there are processes awaiting execution
      currentProcess = list.getNode();
      // selected Node is deleted from list
      list.deleteNode(currentProcess);
      initialRunTime = currentProcess->getRunTime();
      CPUBusy = true; // CPU is now running a process
    }

    time = time + 1; // 1 clock cycle elapsed
  }

  auto stop = Clock::now();  // clock stop

  cout << std::endl;
  outputtxt << std::endl;
  cout << list.getvisitedNodesInsert() << " nodes visited for insertion" << std::endl;
  outputtxt << list.getvisitedNodesInsert() << " nodes visited for insertion" << std::endl;
  cout << list.getvisitedNodesSearch() << " nodes visited for searching" << std::endl;
  outputtxt << list.getvisitedNodesSearch() << " nodes visited for searching" << std::endl;
  cout << list.getvisitedNodesDelete() << " nodes visited for deleting" << std::endl;
  outputtxt << list.getvisitedNodesDelete() << " nodes visited for deleting" << std::endl;
  outputtxt.close();
}


 // Driver Code

int main()
{
 // CODE 1: Reading the Contents of ‘processes.txt’ into the Array

  std::ifstream processesFile;;
  processesFile.open("processes1000.txt");

  int numProcesses = 0;

  if (processesFile.is_open())
  {
    processesFile >> numProcesses;

    Node** processList = new Node*[numProcesses];

    int processID, arrivalTime, runTime, priority;

    for (int i = 0; i < numProcesses; ++i) {
      /* read 4 integers from file */
      processesFile >> processID >> arrivalTime >> runTime >> priority;
      /* construct i'th element of the array */
      processList[i] = new Node(processID, arrivalTime, runTime, priority);
    }

    processesFile.close();

    // process scheduler with linked list
    processSchedulerLinkedList(processList, numProcesses);

    // process scheduler with binary search tree
    processSchedulerTree(processList, numProcesses);
  }

  return 0;
}
//---------------------------------------- PROGRAM FINISHES HERE ------------------------------------------------------------------

/* ******************************* COMMENTS **************************************

1) Process100.txt => Linked list implementation is more efficient then tree.
2) Process500.txt => Tree implementation is more efficient then linked list
3) Process1000.txt => Tree implementation is more efficient then linked list.

General comment : As the number of processes are increased, tree implementation is much more efficient than linked list implementation.








