using Profile = contosoTraders.Api.Core.Models.Implementations.Dao.Profile;

namespace contosoTraders.Api.Core.Services.Interfaces;

internal interface IProfileService
{
    IEnumerable<Profile> GetAllProfiles();

    Profile GetProfile(string email);
}