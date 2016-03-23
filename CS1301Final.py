#Mason DiMarco A7 mdimarco3@gatech.edu worked on alone

def WolframBeta():

    #Function zone
        def matrixMaker(rows, columns):
            rows = int(rows)
            columns = int(columns)
            Matrix = {}

            for row in range(rows):
                for col in range(columns):
                    inp = input("Please enter your value for row " + str(row+1) + " col " + str(col+1))
                    inp = float(inp)
                    pos = (row+1,col+1)#starts coordinates at (1,1)
                    Matrix[pos] = inp

            return Matrix

        def matrixPrint(Matrix):

            #Finds the # of rows and # of columns of the matrix
            keys = Matrix.keys()

            numCols = 0
            numRows = 0


            for key in keys:
                if key[1] > numCols:
                    numCols = key[1] #The number of columns
                if key[0] > numRows:
                    numRows = key[0] # The number of rows


            #Does the Physical Printing
            print("Loading Loading .....")
            print(".........")
            print("Done!")
            for row in range(1,numRows+1):
                for col in range(1,numCols+1):
                    pos = row,col
                    print (Matrix[pos], end=" \t")

                    if col == (numCols):
                        print()


        def matrixAddition(matrix1, matrix2):
            matrix3 = {}
            positions = matrix1.keys()

            if len(matrix1) == len(matrix2):

                for x in range(len(matrix1)):
                    matrix3[positions[x]] = matrix1[positions[x]] + matrix2[positions[x]]

                return matrix3

            else:
                print("These Matrices don't match up!")

        def matrixTransposer(matrix):
            transposedMatrix = {}
            keys = matrix.keys()
            keys.sort()

            for key in keys:
                transposedMatrix[(key[1],key[0])] = matrix[(key[0],key[1])]
            return transposedMatrix


        def matrixMultiplier(matrix1,matrix2):

            #Finds the # of rows and # of columns of each matrix
            keys1 = matrix1.keys()
            keys2 = matrix2.keys()

            numCols1 = 0
            numRows1 = 0
            numRows2 = 0

            for key in keys1:
                if key[1] > numCols1:
                    numCols1 = key[1]
                if key[0] > numRows1:
                    numRows1 = key[0]

            for key in keys2:
                if key[0] > numRows2:
                    numRows2 = key[0]

            print(numCols1, "\t",numRows1,"\t", numRows2)

            if numCols1 == numRows2:


                matrix1 = matrixTransposer(matrix1) #columns of matrix1 are now the rows! therefore it is now (numCols1, numRows1)

                print(matrix1)
                print(matrix2)
        
                matrixProd = {}

                for mat1col in range(1,numRows1+1): # Multiplying to make full columns
                    for mat2col in range(1, numRows1+1): #Multiplying to make full row
                        matrixVals = []
        
                        counter = 1
                        for matrow in range(1, numCols1+1): #Multiplying of element by element

                            indProd = matrix1[matrow,mat1col] * matrix2[matrow,mat2col]
        
                            counter = counter + 1
                            matrixVals.append(indProd)
                        product = reduce(lambda x,y:x+y, matrixVals)
                        matrixProd[mat1col,mat2col] = product

                return matrixProd

            else:
                 print("Incorrect Matrix Dimensions!")
                 return


        def determinant(matrix):

            def positionReset(matrix):
                #Resets the position values of a matrix
                oldkeys = matrix.keys()#remain unchanged
                oldkeys.sort()
                keys = matrix.keys()
                keys.sort() #sorts list by rows
            

            
                from math import sqrt #Finds Num of Cols
                numCols = int(sqrt(len(keys)))
                numRows = numCols #Square Matrix
            

                counter = 0
                for row in range(1,numRows+1):
                    for col in range(1,numCols+1):
                        keys[counter] = (row,col)
                        counter = counter + 1
            
                newMatrix = {}
            
                for x in range(len(keys)):
                    newMatrix[keys[x]] = matrix[oldkeys[x]]
                return newMatrix



            #Assuming a square 2x2 or 3x3 matrix is entered
            keys = matrix.keys()
            numCols = 0

            for key in keys:
                if key[1] > numCols: #Finds the number of columns
                    numCols = key[1]

            def detOf2(matrix):
                #Assumed 2x2 matrix entered

                pos = matrix.keys() #makes sure that no matter what the position 'says', it multiplies 1,1 by 2,2 and 1,2 by 2,1
                pos.sort()

                det = (matrix[pos[0]] * matrix[pos[3]]) - (matrix[pos[1]] * matrix[pos[2]])

                return det

            #removes 1st row, and column position
            def matrixFilter(matrix, column):
                positions = matrix.keys()
                newMat = {}


                for pos in positions:
                    if (pos[0] != 1 )  and (pos[1] != column):
                        newMat[pos] = matrix[pos]

                return newMat


            if numCols == 2:
                det = detOf2(matrix)
                return det

            individualDets = []

            for col in range(1, numCols+1):

                if col % 2 == 0: # accounts for (-1)^i+j
                    matrix[1,col] = matrix[1,col] * -1


                matrixFilt = matrixFilter(matrix,col)
                matrixFilt = positionReset(matrixFilt) # Ensures position values are standardized
                determin = matrix[1,col] * (determinant(matrixFilt))

                individualDets.append(determin)

            if individualDets == []: #accounts for 0 val in first row
                return 0
            finalDet = reduce(lambda x,y:x+y, individualDets)
            return finalDet



        def menu():
            print("You may now choose which operation you would like to run. Please enter the number corresponding to the correct operation")
            print("1. Matrix addition")
            print("2. Matrix multiplication")
            print("3. Matrix Transposition")
            print("4. Determinant Calculation")
            print("5. Exit")

            choice = input("Which Operation would you prefer?")
            try:
                choice = int(choice)

            except:
                print("incorrect choice!")
                menu()

            if choice == 1:
                rows = input("How many Rows should the matrices have?")
                columns = input("And how many columns?")
                matrix1 = matrixMaker(rows,columns)
                matrix2 = matrixMaker(rows,columns)
                matrix3 = matrixAddition(matrix1,matrix2)
                print("You added: ")
                matrixPrint(matrix1)
                print()
                print(" And ")
                matrixPrint(matrix2)
                print()
                print(" To produce: ")
                matrixPrint(matrix3)
                print("!!!")
                menu()
            if choice == 2:
                rows = input("How many rows should the first matrix have?")
                columns = input("And how many columns?")
                rows2 = input("And how many rows should the second matrix have?")
                columns2 = input("And how many columns?")
                matrix1 = matrixMaker(rows,columns)
                matrix2 = matrixMaker(rows2,columns2)
                matrix3 = matrixMultiplier(matrix1,matrix2)
                print("You multiplied: ")
                matrixPrint(matrix1)
                print()
                print(" And ")
                matrixPrint(matrix2)
                print()
                print(" To produce: ")
                matrixPrint(matrix3)
                print("!!!")
                menu()
            if choice == 3:
                rows = input("How many rows should the matrix have?")
                columns = input("And how many columns?")
                matrix1 = matrixMaker(rows,columns)
                matrix1Trans = matrixTransposer(matrix1)
                print("You transposed: ")
                matrixPrint(matrix1)
                print()
                print("To produce: ")
                matrixPrint(matrix1Trans)
                menu()
            if choice == 4:
                rows = input("How many rows should the matrix have?")
                columns = input("And how many columns?")
                matrix1 = matrixMaker(rows,columns)
                determ = determinant(matrix1)
                print("The determinant of")
                matrixPrint(matrix1)
                print()
                print(" is: ", determ)
                menu()
            if choice == 5:
                return





#Visible Program starts here

        print("Welcome to WolframBeta, by far the best knockoff of wolfram alpha so far!")
        print("Your probably wondering right now, how could I have stumbled upon such a gem in an intro to computer science class? and are on the edge of your seat" )
        print("for more, well calm down there, Hoss, first we need to make a matrix!")


        numRows = input("How many rows would you like this wonderful matrix to have?")
        numCols = input("And while you're at it, how many columns?")

        numRows = int(numRows)
        numCols = int(numCols)

        Matrix1 = matrixMaker(numRows,numCols)
        matrixPrint(Matrix1)


        print("Congratulations on making your first matrix!" )
        print("Below is a menu of operations you can perform on your matrices, including creating more matrices to perform operations on.")
        menu()