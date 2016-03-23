# version code 5c5fd42b2587
# Please fill out this stencil and submit using the provided submission script.

# Be sure that the file voting_record_dump109.txt is in the matrix/ directory.



file1 = open("voting_record_dump109.txt", "r")
strlist = list(file1)


## 1: (Task 2.12.1) Create Voting Dict
def create_voting_dict(strlist):
    """
    Input: a list of strings.  Each string represents the voting record of a senator.
           The string consists of 
              - the senator's last name, 
              - a letter indicating the senator's party,
              - a couple of letters indicating the senator's home state, and
              - a sequence of numbers (0's, 1's, and negative 1's) indicating the senator's
                votes on bills
              all separated by spaces.
    Output: A dictionary that maps the last name of a senator
            to a list of numbers representing the senator's voting record.
    Example: 
        >>> create_voting_dict(['Kennedy D MA -1 -1 1 1', 'Snowe R ME 1 1 1 1'])
        {'Snowe': [1, 1, 1, 1], 'Kennedy': [-1, -1, 1, 1]}

    You can use the .split() method to split each string in the
    strlist into a list; the first element of the list will be the senator's
    name, the second will be his/her party affiliation (R or D), the
    third will be his/her home state, and the remaining elements of
    the list will be that senator's voting record on a collection of bills.

    You can use the built-in procedure int() to convert a string
    representation of an integer (e.g. '1') to the actual integer
    (e.g. 1).

    The lists for each senator should preserve the order listed in voting data.
    In case you're feeling clever, this can be done in one line.
    """
    return { curr_str.split(" ")[0]: [int(x) for x in curr_str.split(" ")[3: ] ] for curr_str in strlist }




## 2: (Task 2.12.2) Policy Compare
def policy_compare(sen_a, sen_b, voting_dict):
    """
    Input: last names of sen_a and sen_b, and a voting dictionary mapping senator
           names to lists representing their voting records.
    Output: the dot-product (as a number) representing the degree of similarity
            between two senators' voting policies
    Example:
        >>> voting_dict = {'Fox-Epstein':[-1,-1,-1,1],'Ravella':[1,1,1,1]}
        >>> policy_compare('Fox-Epstein','Ravella', voting_dict)
        -2
    The code should correct compute dot-product even if the numbers are not all in {0,1,-1}.
        >>> policy_compare('A', 'B', {'A':[100,10,1], 'B':[2,5,3]})
        253
        
    You should definitely try to write this in one line.
    """
    return sum( [ x*y for x,y in zip(voting_dict[sen_a], voting_dict[sen_b]) ] )



## 3: (Task 2.12.3) Most Similar
def most_similar(sen, voting_dict):
    """
    Input: the last name of a senator, and a dictionary mapping senator names
           to lists representing their voting records.
    Output: the last name of the senator whose political mindset is most
            like the input senator (excluding, of course, the input senator
            him/herself). Resolve ties arbitrarily.
    Example:
        >>> vd = {'Klein': [1,1,1], 'Fox-Epstein': [1,-1,0], 'Ravella': [-1,0,0]}
        >>> most_similar('Klein', vd)
        'Fox-Epstein'

    Note that you can (and are encouraged to) re-use you policy_compare procedure.
    """
    
    return max( [ x for x in voting_dict.keys() if x!= sen] ,  key=lambda r: policy_compare( sen, r,voting_dict) )



## 4: (Task 2.12.4) Least Similar
def least_similar(sen, voting_dict):
    """
    Input: the last name of a senator, and a dictionary mapping senator names
           to lists representing their voting records.
    Output: the last name of the senator whose political mindset is least like the input
            senator.
    Example:
        >>> vd = {'Klein': [1,1,1], 'Fox-Epstein': [1,-1,0], 'Ravella': [-1,0,0]}
        >>> least_similar('Klein', vd)
        'Ravella'
    """
    return min( [ x for x in voting_dict.keys() if x!= sen] ,  key=lambda r: policy_compare( sen, r,voting_dict) )



## 5: (Task 2.12.5) Chafee, Santorum
voting_dict = create_voting_dict(strlist)


most_like_chafee    =  most_similar('Chafee', voting_dict )
least_like_santorum =  least_similar('Santorum', voting_dict) 



## 6: (Task 2.12.7) Most Average Democrat
def find_average_similarity(sen, sen_set, voting_dict):
    """
    Input: the name of a senator, a set of senator names, and a voting dictionary.
    Output: the average dot-product between sen and those in sen_set.
    Example:
        >>> vd = {'Klein': [1,1,1], 'Fox-Epstein': [1,-1,0], 'Ravella': [-1,0,0]}
        >>> find_average_similarity('Klein', {'Fox-Epstein','Ravella'}, vd)
        -0.5
    """
    return sum( [policy_compare(sen, x, voting_dict) for x in sen_set ] )/len(sen_set)




dems = {x.split(" ")[0] for x in strlist if x.split(" ")[1] == 'D'}
sen_set = voting_dict.keys()

most_average_Democrat = min( [ dem for dem in dems], key=lambda x:find_average_similarity(x,sen_set,voting_dict) ) # give the last name (or code that computes the last name)
#print(most_average_Democrat)


## 7: (Task 2.12.8) Average Record
def find_average_record(sen_set, voting_dict):
    """
    Input: a set of last names, a voting dictionary
    Output: a vector containing the average components of the voting records
            of the senators in the input set
    Example: 
        >>> voting_dict = {'Klein': [-1,0,1], 'Fox-Epstein': [-1,-1,-1], 'Ravella': [0,0,1]}
        >>> find_average_record({'Fox-Epstein','Ravella'}, voting_dict)
        [-0.5, -0.5, 0.0]
    """
    return [ sum( voting_dict[sen][i] for sen in sen_set )/len(sen_set) for i in range(len( list(voting_dict.values())[0]  ))  ]

average_Democrat_record = find_average_record(dems, voting_dict) # give the vector as a list
#print(average_Democrat_record)


## 8: (Task 2.12.9) Bitter Rivals
def bitter_rivals(voting_dict):
    """
    Input: a dictionary mapping senator names to lists representing
           their voting records
    Output: a tuple containing the two senators who most strongly
            disagree with one another.
    Example: 
        >>> voting_dict = {'Klein': [-1,0,1], 'Fox-Epstein': [-1,-1,-1], 'Ravella': [0,0,1]}
        >>> bitter_rivals(voting_dict)
        ('Fox-Epstein', 'Ravella')
    """
    rivals = min( [x,y for x in voting_dict.keys() for y in voting_dict.keys() if x!=y], key= lambda z:  policy_compare(z[0], z[1], voting_dict) )
    return (rivals[0], rivals[1])

#print(bitter_rivals(voting_dict))
