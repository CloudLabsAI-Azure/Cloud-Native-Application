using Profile = TailwindTraders.Api.Core.Models.Implementations.Dao.Profile;

namespace TailwindTraders.Api.Core.Services.Implementations;

internal class ProfileService : TailwindTradersServiceBase, IProfileService
{
    private readonly ProfilesDbContext _profileRepository;

    public ProfileService(ProfilesDbContext profileRepository, IMapper mapper, IConfiguration configuration) : base(mapper, configuration)
    {
        _profileRepository = profileRepository;
    }

    public IEnumerable<Profile> GetAllProfiles()
    {
        return _profileRepository.Profiles.ToList();
    }

    public Profile GetProfile(string email)
    {
        var profile = _profileRepository.Profiles.SingleOrDefault(profile => profile.Email == email);

        if (profile is null) throw new ProfileNotFoundException(email);

        return profile;
    }
}