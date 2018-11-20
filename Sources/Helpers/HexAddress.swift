//
//  HexAddress.swift
//  LottieXtend-iOS
//
//  Created by José Donor on 18/11/2018.
//


/// Hexadecimal address of the object.
///
/// - Parameter object: Object.
/// - Returns: The  hexadecimal address.
func hexAddress(_ object: AnyObject) -> String {
	return Unmanaged<AnyObject>.passUnretained(object).toOpaque().debugDescription
}
