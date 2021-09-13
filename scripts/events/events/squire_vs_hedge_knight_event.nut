this.squire_vs_hedge_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Squire = null,
		HedgeKnight = null
	},
	function create()
	{
		this.m.ID = "event.squire_vs_hedge_knight";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]%squire% le jeune écuyer observe %hedgeknight% à bonne distance. Le chevalier errant est en train d\'aiguiser ses lames, passant une pierre à aiguiser sur les bords et caressant les métaux pour leur donner un bon éclat. Voyant que l\'écuyer le regarde fixement, le chevalier errant baisse son équipement.%SPEECH_ON%Alors tu veux être chevalier, c\'est ça ? %SPEECH_OFF%squire% hoche la tête et répond fièrement.%SPEECH_ON%C\'est mon rêve, oui, et un jour ça arrivera.%SPEECH_OFF%Le chevalier errant se lève et s\'avance vers le jeune homme, le surplombant.%SPEECH_ON%Qu\'est-ce que tu crois qu\'un chevalier fait ? Sauver les jeunes filles ? Diriger des fiefs pour être aimé des paysans ? Doit faire allégeance à son seigneur ? Laisse-moi te dire que c\'est des conneries. Les imbéciles délicats comme toi ne sont rien d\'autre que des vers de terre. Si tu veux être un chevalier tu dois apprendre à tuer.%SPEECH_OFF%L\'écuyer se redresse et met ses épaules en arrière.%SPEECH_ON%Je n\'ai aucun problème à tuer.%SPEECH_OFF%Le chevalier de la haie repousse l\'homme d\'un seul doigt.%SPEECH_ON%C\'est vrai ? Et as-tu éviscéré un homme et assassiné sa famille pendant qu\'il se vidait de son sang sur le sol ? Et écraser la tête d\'un enfant dans vos mains parce que votre seigneur vous en a donné l\'ordre ? Avez-vous arraché les yeux d\'une femme parce que votre seigneur croyait que c\'était la punition pour avoir volé un pain ? Qui pensez-vous que je sois, écuyer ? Crois-tu que je sois né grand, méchant et sauvage ? Non, petit écuyer, tu devras tuer, et celui que tu tueras en premier n\'est autre que toi-même. C\'est ainsi que l\'on devient chevalier dans ces terres, à cette époque.%SPEECH_OFF%Le chevalier errant retourne à son travail. L\'écuyer est visiblement secoué, mais semble réfléchir sérieusement à ce qu\'il vient d\'entendre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La vie n\'est pas un conte de fées.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Squire.getImagePath());
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				_event.m.Squire.getFlags().set("squire_vs_hedge_knight", true);
				local resolve = this.Math.rand(1, 4);
				_event.m.Squire.getBaseProperties().Bravery += resolve;
				_event.m.Squire.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Squire.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
				});
				_event.m.Squire.worsenMood(1.5, "A été ébranlé dans ses convictions");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Squire.getMoodState()],
					text = _event.m.Squire.getName() + this.Const.MoodStateEvent[_event.m.Squire.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local squire_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 4 && bro.getBackground().getID() == "background.squire" && !bro.getFlags().has("squire_vs_hedge_knight"))
			{
				squire_candidates.push(bro);
			}
		}

		if (squire_candidates.len() == 0)
		{
			return;
		}

		local hk_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hk_candidates.push(bro);
			}
		}

		if (hk_candidates.len() == 0)
		{
			return;
		}

		this.m.Squire = squire_candidates[this.Math.rand(0, squire_candidates.len() - 1)];
		this.m.HedgeKnight = hk_candidates[this.Math.rand(0, hk_candidates.len() - 1)];
		this.m.Score = (squire_candidates.len() + hk_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"squire",
			this.m.Squire.getNameOnly()
		]);
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Squire = null;
		this.m.HedgeKnight = null;
	}

});

