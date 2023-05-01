using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {
	private AudioSource pickupSoundSource;

	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void Update() {
		if(transform.position.y < -10){
			MazeCounter.mazeCounter = 0;
			LevelGenerator.numHoles = 4;
			DontDestroy.instance.GetComponents<AudioSource>()[0].Stop();
			SceneManager.LoadScene("GameOver");
		}
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Pickup") {
			pickupSoundSource.Play();
			MazeCounter.mazeCounter++;
			LevelGenerator.numHoles = 4;
			SceneManager.LoadScene("Play");
		}
	}
}
