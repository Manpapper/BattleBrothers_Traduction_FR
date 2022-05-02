this.lose_addiction_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lose_addiction";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%addict% entre dans votre tente, les mains derrière le dos, dans une posture respectueuse. Il vous demande si vous avez un moment. Vous acquiescez et il déclare qu\'il est débarrassé de ses tremblements et de ses maux. Vous lui demandez ce qu\'il veut dire. Il tourne sa main au-dessus de sa bouche comme s\'il prenait une gorgée.%SPEECH_ON%Les potions, monsieur, je n\'ai plus d\'affinités excessives pour ces choses. Je suis bien. C\'est bon. Tout à fait sain. Prêt à me battre comme l\'homme que je suis.%SPEECH_OFF%Vous ne savez pas vraiment où il veut en venir. Vous pensiez que la plupart des hommes prenaient de l\'alcool, mais vous n\'avez aucun problème avec ça. Quoi qu\'il en soit, il semble qu\'il ait surmonté ça. | Vous trouvez %addict% assis par terre en train de regarder ses paumes. Il suit les sillons avec un doigt.%SPEECH_ON%Je vous entends, monsieur.%SPEECH_OFF%En hochant la tête, vous lui demandez ce qu\'il fait. Il sourit.%SPEECH_ON%Je me sens mieux. J\'ai l\'impression que je n\'ai plus besoin de me défouler avec ces potions. Je me sens moi-même, je suppose. Prêt à tuer, selon vos ordres, monsieur, et à le faire avec la clarté d\'esprit de savoir ce que je fais et pourquoi.%SPEECH_OFF%Super. Vous n\'êtes pas sûrs de ce que c\'était mais vous lui souhaitez bonne chance pour rester comme ça.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon travail à toi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local trait = _event.m.Addict.getSkills().getSkillByID("trait.addict");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Addict.getName() + " n\'est plus dépendant"
				});
				_event.m.Addict.getSkills().remove(trait);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getFlags().get("PotionLastUsed") >= 14.0 * this.World.getTime().SecondsPerDay && bro.getSkills().hasSkill("trait.addict"))
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 5 + candidates_addict.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
	}

});

