this.nightowl_catches_thief_event <- this.inherit("scripts/events/event", {
	m = {
		NightOwl = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.nightowl_catches_thief";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{En vous réveillant d\'un rêve étrange, vous sortez de votre tente et trouvez la plupart des membres de la compagnie endormis, à l\'exception du noctambule %nightowl%. Il est à l\'extrémité du camp, le dos tourné, mais il semble vous entendre approcher et parle sans se retourner.%SPEECH_ON%C\'est comme ça que ça commence, monsieur. La rage. La fièvre. Ça transforme les hommes bons, hoooo.%SPEECH_OFF%Il tourne autour pour montrer une chouette qu\'il a attrapée. Ses paupières sont à moitié fermées, probablement épuisées par la fuite et maintenant humiliée d\'avoir été capturée sans aucun but carnivore. Vous demandez à %nightowl% comment il a pu l\'attraper. Le mercenaire laisse partir l\'oiseau et hausse les épaules.%SPEECH_ON%Avec mes mains. J\'ai aussi attrapé ça.%SPEECH_OFF%Il s\'accroupit et soulève un cadavre jusqu\'alors caché.%SPEECH_ON%Petit voleur rusé. Je suis tombé sur lui, euh, en train de vendre nos produits au rabais pour ainsi dire. J\'étais un peu trop fatigué pour parler, alors j\'ai laissé ma lame lui dire que la boutique était fermée. J\'ai ensuite suivi ses pas jusqu\'à l\'endroit d\'où il venait et j\'ai trouvé ses, eh, disons, accoutrements.%SPEECH_OFF%Vous acquiescez. C\'est vrai. Bien sûr. Vous dites à l\'homme que vous allez vous rendormir et que vous jugerez de ce qu\'il fait demain matin. Il obéit.%SPEECH_ON%Bien monsieur. Je vais essayer de dormir un peu moi aussi. Ça fait quelques jours. Ou était-ce des semaines?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reposez-vous bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NightOwl.getImagePath());
				_event.m.NightOwl.improveMood(1.0, "Caught a thief at night");

				if (_event.m.NightOwl.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.NightOwl.getMoodState()],
						text = _event.m.NightOwl.getName() + this.Const.MoodStateEvent[_event.m.NightOwl.getMoodState()]
					});
				}

				local trait = this.new("scripts/skills/effects_world/exhausted_effect");
				_event.m.NightOwl.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.NightOwl.getName() + " est épuisé"
				});
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getSkills().hasSkill("trait.night_owl"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NightOwl = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"nightowl",
			this.m.NightOwl.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.NightOwl = null;
		this.m.FoundItem = null;
	}

});

