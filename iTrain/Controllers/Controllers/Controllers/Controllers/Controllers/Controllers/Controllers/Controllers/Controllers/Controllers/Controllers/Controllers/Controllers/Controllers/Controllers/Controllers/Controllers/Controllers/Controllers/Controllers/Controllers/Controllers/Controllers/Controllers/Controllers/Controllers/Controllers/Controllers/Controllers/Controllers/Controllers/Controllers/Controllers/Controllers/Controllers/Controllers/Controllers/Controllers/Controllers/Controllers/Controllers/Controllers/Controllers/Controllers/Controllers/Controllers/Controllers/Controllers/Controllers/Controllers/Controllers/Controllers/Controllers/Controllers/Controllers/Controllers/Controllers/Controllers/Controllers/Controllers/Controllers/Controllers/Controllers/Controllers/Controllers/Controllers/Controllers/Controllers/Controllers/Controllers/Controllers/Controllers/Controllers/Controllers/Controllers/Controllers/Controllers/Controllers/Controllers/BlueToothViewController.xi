<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="4510" systemVersion="13E28" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none">
    <dependencies>
        <deployment defaultVersion="1536" identifier="iOS"/>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="3742"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner" customClass="BlueToothViewController">
            <connections>
                <outlet property="tv" destination="ONW-Lo-C6U" id="gbD-Lv-x9P"/>
                <outlet property="view" destination="1" id="3"/>
            </connections>
        </placeholder>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view contentMode="scaleToFill" id="1">
            <rect key="frame" x="0.0" y="0.0" width="320" height="568"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <tableView clipsSubviews="YES" contentMode="scaleToFill" alwaysBounceVertical="YES" style="plain" separatorStyle="default" rowHeight="44" sectionHeaderHeight="22" sectionFooterHeight="22" id="ONW-Lo-C6U">
                    <rect key="frame" x="0.0" y="66" width="320" height="502"/>
                    <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                    <color key="backgroundColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                    <color key="sectionIndexTrackingBackgroundColor" red="1" green="0.49019610879999997" blue="0.49019610879999997" alpha="1" colorSpace="deviceRGB"/>
                </tableView>
                <label opaque="NO" clipsSubviews="YES" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="设备" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" id="dWm-GG-3Eq">
                    <rect key="frame" x="14" y="37" width="42" height="21"/>
                    <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                    <fontDescription key="fontDescription" type="system" pointSize="17"/>
                    <color key="textColor" cocoaTouchSystemColor="darkTextColor"/>
                    <nil key="highlightedColor"/>
                </label>
            </subviews>
            <color key="backgroundColor" red="0.93725490196078431" green="0.93725490196078431" blue="0.93725490196078431" alpha="1" colorSpace="calibratedRGB"/>
            <simulatedStatusBarMetrics key="simulatedStatusBarMetrics"/>
            <simulatedScreenMetrics key="simulatedDestinationMetrics" type="retina4"/>
        </view>
    </objects>
</document>