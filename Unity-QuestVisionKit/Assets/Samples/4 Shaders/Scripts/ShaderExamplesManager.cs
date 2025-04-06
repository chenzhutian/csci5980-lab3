using UnityEngine;

public class ShaderExamplesManager : MonoBehaviour
{
    [SerializeField]
    GameObject[] shaderExamples;

    int currentExampleIndex = 0;

    Vector3 initialPos;
    Quaternion initialRot;

    private void Awake()
    {
        initialPos = shaderExamples[0].transform.position;
        initialRot = shaderExamples[0].transform.rotation;
    }

    public void RightButtonPressed()
    {
        currentExampleIndex = (currentExampleIndex >= shaderExamples.Length-1) ? 0 : currentExampleIndex + 1;
        EnableCurrentExamples();
    }

    public void LeftButtonPressed()
    {
        currentExampleIndex = (currentExampleIndex <= 0) ? shaderExamples.Length-1 : currentExampleIndex - 1;
        EnableCurrentExamples();
    }

    void EnableCurrentExamples()
    {
        for (int i = 0; i < shaderExamples.Length; i++)
        {
            shaderExamples[i].SetActive(i == currentExampleIndex);

            shaderExamples[i].transform.position = initialPos;
            shaderExamples[i].transform.rotation = initialRot;
        }
    }
}