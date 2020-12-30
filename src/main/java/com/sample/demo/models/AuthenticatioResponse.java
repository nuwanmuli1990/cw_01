package com.sample.demo.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class AuthenticatioResponse {

	private final String jwt;
}
