


import numpy as np
import matplotlib.pyplot as plt


svm_cval = [ 0.73225,   0.734625,  0.710625,   0.7345,    0.72535,  0.7225,    0.7348,  0.73975,   0.73087,  0.7265 ]
log_cval = [ 0.75375,   0.75725,   0.730375,  0.75,      0.74925,   0.739375,  0.753625, 0.7565,    0.75125,   0.74    ]
nb_cval = [ 0.746,     0.747,     0.7278,  0.7378,  0.73825,   0.734,  0.75175, 0.743,  0.743,  0.736]


x = np.arange(0,len(svm_cval),1)


svm = plt.plot(x,svm_cval,'r',label="SVM")
log = plt.plot(x,log_cval,'g',label="Log")
nb  = plt.plot(x,nb_cval,'b',label="NB")
plt.title("Cross Validations")
plt.ylabel('Accuracy')
plt.xlabel('Fold')
plt.axis([0,9,.7,.80])
plt.legend()


width = .3
train_acc = [0.8926, 0.84405, 0.826]
test_acc = [0.763, 0.788, 0.785]
inds = np.arange(3) 


fig, ax = plt.subplots()

tr = ax.bar(inds,train_acc,width,color='r')
te = ax.bar(inds+width,test_acc,width,color='b')

ax.set_title("Train vs. Test Accuracies")
ax.legend( (tr[0],te[1]), ('Train', 'Test') )
ax.set_xticks(inds+width)
ax.set_xticklabels( ('SVM', 'Log', 'NB') )
ax.set_ylim(0,1)
ax.set_ylabel("Accuracy")

plt.show()
