this.oathtaker_mistaken_identity_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_mistaken_identity";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 70.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%{Un garçon court soudainement vers la compagnie. Il s\'accroche pratiquement à la jambe de %oathtaker%, le visage de ce dernier prend une apparence de confusion. Il demande à l\'avorton s\'il est perdu. Le garçon recule d\'un coup sec.%SPEECH_ON%Perdu? Non, je ne suis pas perdu! Je pensais ne jamais revoir votre espèce, les fameux Oathbringers!%SPEECH_OFF%L\'œil de %oathtaker% tressaute, ses mains se crispent autour du manche de son arme. Vous ne savez pas exactement quand ses cris ont commencé et quand le garçon s\'est retrouvé par terre avec un cocard, mais une rage légitime a jailli du Oathtaker, vous le regardez pousser le garçon dans la boue en hurlant et en écumant qu\'il est un Oathtaker, et non pas un horrible, laid et ingrat Oathbringer. Il écrase le visage du garçon dans l\'herbe et le traîne dans un tas de crottin de cheval jusqu\'à ce que le garçon hurle et s\'enfuit pour sauver sa vie. %oathtaker% se redresse, fixant sa tenue, remettant en place son armement en désordre.%SPEECH_ON%Quittons cet enfer de dégénérés crasseux, capitaine.%SPEECH_OFF%Alors qu\'il s\'éloigne, vous vous retournez pour voir les habitants vous regarder avec horreur.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est à peu près ce à quoi ça ressemble.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
				this.World.Assets.addMoralReputation(-1);
				local f = _event.m.Town.getFactionOfType(this.Const.FactionType.Settlement);
				f.addPlayerRelation(this.Const.World.Assets.RelationMinorOffense, "One of your men beat up a kid");
				_event.m.Oathtaker.worsenMood(2.0, "Was mistaken for an Oathbringer");

				if (_event.m.Oathtaker.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local oathtaker_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				oathtaker_candidates.push(bro);
			}
		}

		if (oathtaker_candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = oathtaker_candidates[this.Math.rand(0, oathtaker_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 3 * oathtaker_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
		this.m.Town = null;
	}

});

