// Code generated by Wire. DO NOT EDIT.

//go:generate go run github.com/google/wire/cmd/wire
//go:build !wireinject
// +build !wireinject

package factory

import (
	"github.com/emochka2007/block-accounting/internal/pkg/config"
	"github.com/emochka2007/block-accounting/internal/service"
)

// Injectors from wire.go:

func ProvideService(c config.Config) (service.Service, func(), error) {
	logger := provideLogger(c)
	repository, cleanup, err := provideUsersRepository(c)
	if err != nil {
		return nil, nil, err
	}
	usersInteractor := provideUsersInteractor(logger, repository)
	jwtInteractor := provideJWTInteractor(c)
	authPresenter := provideAuthPresenter(jwtInteractor)
	authController := provideAuthController(logger, usersInteractor, authPresenter)
	rootController := provideControllers(logger, authController)
	server := provideRestServer(logger, rootController, c)
	serviceService := service.NewService(logger, server)
	return serviceService, func() {
		cleanup()
	}, nil
}
