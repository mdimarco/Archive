import java.util.Random;


public class Forecaster {
	double[] weights;
	double c = .001;
	
	/**
	 * This forecaster will have 3 parameters to its weights, the temperature,
	 * humidity, and a bias value, using these three things it will determine
	 * whether or not it's going to rain!
	 */
	public Forecaster(){
		weights = new double[3];
		
		
		Random randy = new Random();
	    for (int i = 0; i < weights.length; i++) {
	      weights[i] = randy.nextDouble()*2-1;
	    }
	    
	}
	
	/**
	 * This is where the actual guess goes, our weights
	 * interact with the inputs in such a way as to guess
	 * what the classification should be
	 * 
	 * @param inputs
	 * @return
	 */
	public int feedForward(double[] inputs){
		double tot = 0;
		for(int i = 0; i< weights.length; i++){
			tot+= weights[i]*inputs[i];
		}
		return activationFunc(tot);
	}
	
	
	/**
	 * Just makes the final decision, a yes or no.
	 * @param forwardGuess
	 * @return
	 */
	public int activationFunc(double forwardGuess){
		if(forwardGuess > 1) return 1;
		else return -1;
	}
	
	/**
	 * Here is where the actual "learning" goes on, for every mistake
	 * that the guess has, an error value is computed based on its 
	 * distance from the actual value, the magnitude of this adjustment
	 * is based on the cost value c, which, when kept low, will prevent 
	 * sporadic changes in the weight values assigned to the perceptron.
	 * 
	 * a low c value will have the perceptron take longer to adjust, but
	 * will help it become much more stable over time!
	 * 
	 * @param inputs
	 * @param actualAnswer
	 */
	public void train(double[] inputs, int actualAnswer){
		int guess = feedForward(inputs);
		int errorVal = actualAnswer - guess;
		for(int i = 0; i< weights.length; i++){
			weights[i] += inputs[i]*errorVal*c;
		}
	}
	
	
	
	/**
	 * A fake formula I have created to determine if the sky should decide
	 * to drop water for the day. Based on the change in temperature in 
	 * pressure that has recently occurred, this function will provide
	 * the training and testing data for the perceptron.
	 * 
	 * @param deltaTemp
	 * @param deltaPress
	 * @return
	 */
	public static int rainFinder(double deltaTemp, double deltaPress){
		double rainGodsDecision = deltaTemp * .2 + deltaPress ;
		if (rainGodsDecision> 3.5 ) return 1;
		else return -1;
	}
	
	
	//Now that all of the pieces have been set for this perceptron, let's see if we can get it to
	//predict the weather!
	
	public static void main(String[] args){
		Forecaster rainOracle = new Forecaster();
		System.out.println(rainOracle.weights[0]);

		
		int count = 0;
		//We will now train the oracle based off of the old rain's history
		Random dataGen = new Random();
		for(int i = 0; i<1000; i++){
			double deltaT = dataGen.nextDouble()*10;
			double deltaP = dataGen.nextDouble()*3;
			
			int rainGodsDecision = rainFinder(deltaT, deltaP);
			if(rainGodsDecision == 1) count++;
			
			
			double[] data = {deltaT, deltaP, 1};
			rainOracle.train(data , rainGodsDecision);
		}
		
		
		
		//Now it's time to see if all of this training was worth it!
		Random testGen = new Random();
		int correct = 0;
		for(int i = 0; i<1000; i++){
			double deltaT = testGen.nextDouble()*10;
			double deltaP = testGen.nextDouble()*3;
			double[] inputs = {deltaT, deltaP, 1};
			
			int guess = rainOracle.feedForward(inputs);
			int rainGodsDecision = rainFinder(deltaT,deltaP);
			
			if(guess == rainGodsDecision) correct++;

		}
		System.out.println(correct);
		
		
		//Now let's say a drastic change to the climate has occured, such that the temperature
		// differences are now extreme!
		correct = 0;
		for(int i = 0; i<1000; i++){
				double deltaT = testGen.nextDouble()*100-50;
				double deltaP = testGen.nextDouble();
				double[] inputs = {deltaT, deltaP, 1};
				
				int guess = rainOracle.feedForward(inputs);
				int rainGodsDecision = rainFinder(deltaT,deltaP);
				
				if(guess == rainGodsDecision) correct++;

		}
		System.out.println(correct);
		
		//It seems to me that regardless of what values we try,
		//a solid fit has been created towards the actual function
		//used to determine weather conditions.
	}
	
	
	
	
}
