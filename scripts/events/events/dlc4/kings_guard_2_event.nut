this.kings_guard_2_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.kings_guard_2";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Vous trouvez %guard% qui s\'étire avec une étonnante souplesse. Il ne ressemble en rien à l\'homme glacial et frigide que vous avez trouvé abandonné dans la glace par ces barbares. Vous repérant, il hoche la tête et s\'approche d\'une voix calme.%SPEECH_ON%Je suis heureux que vous ayez eu confiance en moi, capitaine. Peut-être l\'avez-vous fait par bonté d\'âme, mais je dois vous montrer quelque chose.%SPEECH_OFF%Il brandit un emblème dont vous avez souvent entendu parler, mais que vous n\'avez jamais vu : il porte le sigle de la Garde du Roi et sa brillance est telle qu\'il est impossible que ce soit une farce. L\'homme vous sourit.%SPEECH_ON%Je pense être en bonne santé et prêt à vous servir comme je l\'ai fait pour mon souverain.%SPEECH_OFF%Les rois de ces terres sont tombés depuis longtemps, remplacés par des seigneurs et des nobles qui se chamaillent. Si cet homme peut se battre pour vous comme il l\'a fait pour les rois, alors %companyname% aura sûrement des jours meilleurs devant eux.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suis heureux que nous vous ayons trouvé en ce jour fatidique.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local bg = this.new("scripts/skills/backgrounds/kings_guard_background");
				bg.m.IsNew = false;
				_event.m.Dude.getSkills().removeByID("background.cripple");
				_event.m.Dude.getSkills().add(bg);
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% à moitié gelé dans le nord. Avec votre aide, l\'ancien garde du Roi a retrouvé ses forces et se bat maintenant pour vous.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.improveMood(1.0, "Is his former self again");

				if (_event.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}

				_event.m.Dude.getBaseProperties().MeleeSkill += 12;
				_event.m.Dude.getBaseProperties().MeleeDefense += 7;
				_event.m.Dude.getBaseProperties().RangedDefense += 7;
				_event.m.Dude.getBaseProperties().Hitpoints += 15;
				_event.m.Dude.getBaseProperties().Stamina += 10;
				_event.m.Dude.getBaseProperties().Initiative += 10;
				_event.m.Dude.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Dude.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] de Défense en Mêlée"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Dude.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] de Défense à distance"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Dude.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+12[/color] de Compétence au corps à corps"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Dude.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] de Fatigue Maximum"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Dude.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] d\'Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Dude.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+15[/color] de Points de Vie"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (bro.getDaysWithCompany() >= 30 && bro.getFlags().get("IsKingsGuard"))
			{
				candidate = bro;
				break;
			}
		}

		if (candidate == null)
		{
			return;
		}

		this.m.Dude = candidate;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"guard",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

