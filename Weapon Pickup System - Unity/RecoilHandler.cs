using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RecoilHandler : MonoBehaviour
{
    [SerializeField] private Transform targetObject;
    private Transform actualTargetObject;
    [Header("Position Curves")]
    [SerializeField] private AnimationCurve xPosCurve;
    [SerializeField] private AnimationCurve yPosCurve;
    [SerializeField] private AnimationCurve zPosCurve;
    [Header("Rotation Curves")]
    [SerializeField] private AnimationCurve xRotCurve;
    [SerializeField] private AnimationCurve yRotCurve;
    [SerializeField] private AnimationCurve zRotCurve;
    [Space]
    [SerializeField] private float recoilSpeed = 1f;
    [SerializeField] private float posLerpSpeed = 1f;
    [SerializeField] private float rotLerpSpeed = 1f;
    [Space]
    [SerializeField] private Vector3 recoilPosAmplitude = Vector3.forward;
    [SerializeField] private Vector3 recoilRotAmplitude = Vector3.forward;

    private Vector3 defPos;
    private Vector3 defRot;
    private Vector3 recoilPosTarget;
    private Vector3 recoilRotTarget;
    private float recoilTime;
    
    private void Start()
    {
        if(targetObject) actualTargetObject = targetObject;
        else actualTargetObject = transform;

        defPos = actualTargetObject.localPosition;
        defRot = actualTargetObject.localEulerAngles;
        recoilTime = 1f;
    }

    public void ApplyRecoil()
    {
        recoilTime = 0f;
        EvaluateCurves();
    }

    private void EvaluateCurves()
    {
        recoilPosTarget.x = xPosCurve.Evaluate(recoilTime) * recoilPosAmplitude.x;
        recoilPosTarget.y = yPosCurve.Evaluate(recoilTime) * recoilPosAmplitude.y;
        recoilPosTarget.z = zPosCurve.Evaluate(recoilTime) * recoilPosAmplitude.z;

        recoilRotTarget.x = xRotCurve.Evaluate(recoilTime) * recoilRotAmplitude.x;
        recoilRotTarget.y = yRotCurve.Evaluate(recoilTime) * recoilRotAmplitude.y;
        recoilRotTarget.z = zRotCurve.Evaluate(recoilTime) * recoilRotAmplitude.z;
        recoilRotTarget *= Random.value > 0.5f ? 1f : -1f;
    }

    private void Update()
    {
        if(recoilTime < 1f)
        {
            recoilTime += recoilSpeed * Time.deltaTime;
            EvaluateCurves();

            targetObject.localPosition = Vector3.Lerp(targetObject.localPosition, -recoilPosTarget, posLerpSpeed * Time.deltaTime);
            targetObject.localRotation = Quaternion.Slerp(targetObject.localRotation, Quaternion.Euler(-recoilRotTarget), rotLerpSpeed * Time.deltaTime);
        }
        else
        {
            targetObject.localPosition = Vector3.Lerp(targetObject.localPosition, defPos, posLerpSpeed * Time.deltaTime);
            targetObject.localRotation = Quaternion.Slerp(targetObject.localRotation, Quaternion.Euler(defRot), rotLerpSpeed * Time.deltaTime);
        }
    }
}
