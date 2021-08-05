this.good_food_variety_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.good_food_variety";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_61.png[/img]{Vous regardez les hommes dévorer des assiettes aussi colorées que les personnalités des hommes. Fournir à la compagnie un stock de nourriture aussi varié leur a remonté le moral aussi bien que n\'importe quelle victoire ! | Un repas chaud est ce dont tout homme a besoin, mais un repas chaud, avec quelques accompagnements et entrées ? Eh bien, c\'est tout autre chose ! Grâce à vos achats d\'aliments variés, les hommes se régalent et se sentent bien dans leur peau. | Une nourriture aussi variée que celle de n\'importe quel noble, ou assez proche, en tout cas. C\'est ce que vous avez fourni à la compagnie et les hommes sont extrêmement reconnaissants lorsqu\'ils se régalent.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Profitez en.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}
					else if (bro.getSkills().hasSkill("trait.gluttonous") || bro.getSkills().hasSkill("trait.fat"))
					{
						bro.improveMood(2.0, "A beaucoup apprécié la variété des aliments");
					}
					else
					{
						bro.improveMood(1.0, "A apprécié la variété des aliments");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local hasBros = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.spartan"))
			{
				continue;
			}

			hasBros = true;
			break;
		}

		if (!hasBros)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local food = [];

		foreach( item in stash )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (food.find(item.getID()) == null)
				{
					food.push(item.getID());
				}
			}
		}

		if (food.len() < 4)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

