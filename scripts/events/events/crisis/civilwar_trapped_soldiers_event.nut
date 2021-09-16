this.civilwar_trapped_soldiers_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_trapped_soldiers";
		this.m.Title = "At %town%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]You come across a large throng of peasants in an uproar. Upon closer look, they\'ve surrounded a small band of soldiers carrying the banner of %noblehouse%, who this very village belongs to. Each man has his sword out, but they\'ve been back into a corner and completely outnumbered. The laymen shout and point.%SPEECH_ON%Murderers! Rapists! Arsonists!%SPEECH_OFF%Spitting and tomato throwing follow suit. %randombrother% comes to you and asks if the men should step in or stay out of it.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "We need to put a stop to this.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "This isn\'t our fight.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "D";
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]No man, especially of the fighting stock, deserves to be lynched. You order you men to step in, barking the command loud enough to turn half the crowd around to see you. Gasps ripple through the throng, and you nod confidently.%SPEECH_ON%Step aside, peasants. These men might be deserving of many things, but your unruly justice is not one of them.%SPEECH_OFF%A scruffy layman cries out.%SPEECH_ON%But they\'re murderers and worse!%SPEECH_OFF%You throw a stern look.%SPEECH_ON%And so are my men. Now get out of the way.%SPEECH_OFF%The crowd does as told. The rescued soldiers tell you that %noblehouse% will hear of your deeds here.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That went pretty well. ",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved some of their men");
				this.World.Assets.addMoralReputation(1);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationMinorOffense);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_43.png[/img]There\'s no reason soldiers should be lynched like this. Or, for some reason, the sudden pang of justice in your side says so. With a loud voice, you announce yourself as a neutral third party here to mediate the ongoings. The cordial proceedings last for all over one second before the peasants, more shrill and hysterical than ever, announce that you are but more soldiers from %noblehouse%. You raise your hands to explain, but a melee breaks out.\n\n You can only grimace as you watch your men cut the peasants down one by one, like strong-armed farmers scything through the freshest of wheat fields. It is a gruesome sight and a few bystanders look on in horror before running off, surely to tell others of what you have done here. The soldiers, conversely, thank your bloodied and gore covered men.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Not sure what I expected.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Saved some of their men");
				this.World.Assets.addMoralReputation(-2);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationOffense, "Killed some of their men");
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
					{
						candidates.push(bro);
					}
				}

				local numInjured = this.Math.min(candidates.len(), this.Math.rand(1, 3));

				for( local i = 0; i < numInjured; i = ++i )
				{
					local idx = this.Math.rand(0, candidates.len() - 1);
					local bro = candidates[idx];
					candidates.remove(idx);
					local injury = bro.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " suffers " + injury.getNameOnly()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]Getting involved might simply complicate matters - peasants are fickle and uneducated, seers of their own solitude, purveyors of bad luck and paranoia. You order your men not to just stand aside, but to make themselves small.\n\n A thrown rocks open up the attack, soon followed by a wall of pitchforks and machetes. The soldiers try and put up a fight, but the best summation of their defense is one of horrid screaming. One is dragged out of the pile, kicking and screaming, and the peasants stab him repeatedly until he stops. Another is roped and run up a tree, hanged by the pull of three angry men.\n\nSatiated, the crowd quiets down. Children dance around the dead man\'s feet. A poor and mumbling man lily hops around the corpses, picking through the pockets of each.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "The friction of war meets the madness of the layman.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				this.World.Assets.addMoralReputation(-1);
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]You decide to keep out of it. This isn\'t your fight and involving yourself will only complicate things. Standing back, you watch as the crowd collapses in on the soldiers. There\'s a scuffle, shrill voices pipe over the din of the chaos, squirming cries of those unprepared for such a brutal final moment. But one man pushes his way through the crowd, kicking people off his legs and daggering one man in the eye. He manages to sprint to a nearby horse, mount up, and spur it into a sprint. The man eyes the %companyname%\'s banner as he passes by. You can\'t help but think that %noblehouse% might hear of your neutrality on this day...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "I\'m sure he won\'t say anything.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Refused to help their men");
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 3)
		{
			return;
		}

		this.m.NobleHouse = bestTown.getOwner();
		this.m.Town = bestTown;
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

