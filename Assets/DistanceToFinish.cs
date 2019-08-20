using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DistanceToFinish : MonoBehaviour
{
    private Transform finishLine;
    [SerializeField] Transform Ball;
    private float distance;
    private float totalDistance;
    private float fillAmount;
    private Image levelProgressBar;
    bool isCalculate;

    private RectTransform _edgeRect;
    private RectTransform _imgRect;
    [SerializeField] private float EdgeMargin = 20;


    private void Start()
    {
        isCalculate = true;
        levelProgressBar = gameObject.GetComponent<Image>();
        finishLine = GameObject.Find("FinishLine").GetComponent<Transform>();
        totalDistance = (finishLine.transform.position - Ball.transform.position).magnitude;

        _imgRect = GetComponent<RectTransform>();
        _edgeRect = transform.GetChild(0).GetComponent<RectTransform>();
    }

    private void Update()
    {
        CalculateProgress();
        MovePointer();
    }

    void CalculateProgress()
    {
        if (isCalculate)
        {
            distance = (finishLine.transform.position - Ball.transform.position).magnitude;
            distance = distance / totalDistance;
            fillAmount = Mathf.Abs(1f - distance);
            levelProgressBar.fillAmount = fillAmount;

            /* if (distance > 0 && distance > 0.1)
             {
                 levelProgressBar.fillAmount = fillAmount;
             }

             else if (distance < 0.1)
             {
                 levelProgressBar.fillAmount = 1f;
                 isCalculate = false;

             }
             */
        }
    }

    void MovePointer()
    {
        if (levelProgressBar.type != Image.Type.Filled) return;

        _edgeRect.gameObject.SetActive(!(levelProgressBar.fillAmount == 0));
        _edgeRect.localPosition = new Vector2(levelProgressBar.fillAmount * _imgRect.rect.width - EdgeMargin,
            _edgeRect.localPosition.y);
    }
}

