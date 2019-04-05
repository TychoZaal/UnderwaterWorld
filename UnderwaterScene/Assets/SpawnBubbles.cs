using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnBubbles : MonoBehaviour
{
    public GameObject bubble, parent;
    public float offsetXMin;
    public float offsetXMax;
    public float offsetYMin;
    public float offsetYMax;
    public float offsetZMin;
    public float offsetZMax;
    public int bubblesToSpawn = 5;

    // Update is called once per frame
    void Start()
    {
        SpawnBubble(bubblesToSpawn);
    }

    void SpawnBubble(float amount)
    {
        for (int i = 0; i < amount; i++)
        {
            GameObject bubbleSpawned = Instantiate(bubble, new Vector3(Random.Range(offsetXMin, offsetXMax), Random.Range(offsetYMin, offsetYMax), Random.Range(offsetZMin, offsetZMax)), Quaternion.identity, parent.transform );
            float scale = Random.Range(1, 10);
            bubbleSpawned.transform.localScale = new Vector3(scale, scale, scale);
        }
    }
}
