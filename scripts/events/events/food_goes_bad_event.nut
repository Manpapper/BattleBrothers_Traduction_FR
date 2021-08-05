this.food_goes_bad_event <- this.inherit("scripts/events/event", {
	m = {
		FoodAmount = 0
	},
	function create()
	{
		this.m.ID = "event.food_goes_bad";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On aurait pu utiliser ça...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();
				food = food[this.Math.rand(0, food.len() - 1)];
				this.World.Assets.getStash().remove(food);

				if (food.getID() == "supplies.bread")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Alors qu\'il fait l\'inventaire, %randombrother% vous avertit d\'une mauvaise nouvelle : une bonne quantité de nourriture a pourri. Simple et direct, vous acquiescez et le remerciez de vous avoir prévenu rapidement. | %randombrother% vient vous voir en se frottant la mâchoire. Il dit qu\'il a failli se casser les dents sur un morceau de pain. Apparemment, il a trouvé le morceau au fond d\'une caisse de nourriture et il semble qu\'il soit resté là pendant un certain temps. Vous vous attaquez à la miche avec votre épée, la coupant en deux sous les applaudissements sarcastiques de quelques frères. En prenant le pain coupé en deux, vous montrez aux hommes l\'intérieur : un noyau noir et sombre. Voilà à quoi ressemblera votre estomac si vous mangez ça, dites-vous avant de jeter le pain dans les buissons où vous pouvez l\'entendre dégringoler comme une lourde pierre.}";
				}
				else if (food.getID() == "supplies.dried_fish")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Alors qu\'il fait l\'inventaire, %randombrother% vous avertit d\'une mauvaise nouvelle : une bonne quantité de nourriture a pourri. Simple et direct, vous acquiescez et le remerciez de vous avoir prévenu rapidement. | %randombrother% glapit et bondit de la bûche sur laquelle il était assis. Vous vous approchez pour voir qu\'il a jeté un poisson sur le bord du chemin et qu\'il ne peut s\'empêcher de le montrer du doigt. Alors qu\'il vous avertit de ne pas vous en approcher, vous décidez de le faire. Apparemment, une araignée d\'eau a donné naissance à une couvée d\'oeufs dans l\'abdomen du poisson. Vous regardez maintenant les petites araignées qui se répandent dans un nuage de pattes et de corps qui s\'agitent.\n\nAprès avoir jeté le tout dans un feu, vous demandez aux frères d\'armes de vérifier le reste des poissons. Malheureusement, ils sont tous dans le même état et personne n\'est prêt à remplacer sa nourriture à base de poisson par des araignées.}";
				}
				else if (food.getID() == "supplies.dried_fruits")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Alors qu\'il fait l\'inventaire, %randombrother% vous avertit d\'une mauvaise nouvelle : une bonne quantité de nourriture a pourri. Simple et direct, vous acquiescez et le remerciez de vous avoir prévenu rapidement. | Vous fouillez dans quelques caisses de nourriture pour trouver un carton entier de pommes recouvertes de ce qui ressemble à de la fourrure grise. %randombrother% a un mot pour cela, mais vous ne l\'avez jamais entendu auparavant. Quoi qu\'il en soit, rien ne peut être récupéré et vous jetez les fruits pourris.}";
				}
				else if (food.getID() == "supplies.smoked_ham" || food.getID() == "supplies.cured_venison")
				{
					this.Text = "[img]gfx/ui/events/event_52.png[/img]{Alors qu\'il fait l\'inventaire, %randombrother% vous avertit d\'une mauvaise nouvelle : une bonne quantité de nourriture a pourri. Simple et direct, vous acquiescez et le remerciez de vous avoir prévenu rapidement. | Des asticots s\'agitent autour de quelques morceaux de viande. Vos hommes fixent la nourriture, certains semblant prêts à risquer une maladie pour en manger un morceau. Vous leur dites d\'arrêter et vous vous débarrassez personnellement de la viande avant que quelqu\'un ne fasse une bêtise.}";
				}
				else
				{
					this.Text = "{[img]gfx/ui/events/event_52.png[/img]Alors qu\'il fait l\'inventaire, %randombrother% vous avertit d\'une mauvaise nouvelle : une bonne quantité de nourriture a pourri. Simple et direct, vous acquiescez et le remerciez de vous avoir prévenu rapidement. | [img]gfx/ui/events/event_36.png[/img]Des rires d\'enfants vous réveillent de votre sieste. Vous vous levez pour constater qu\'une partie de la nourriture a disparu et que la seule preuve de son départ est un champ d\'herbes hautes encore en mouvement. Réfléchissant vite, vous prenez une épée et suivez sa trace. Malheureusement, il ne faut pas longtemps avant que vous ne soyez perdu au milieu d\'énormes tiges vertes qui vous heurtent le visage à chaque coup de vent. Les rires ne s\'arrêtent pas pour autant, et vous entendez des bruits de pas se croiser derrière vous, puis devant. Une voix parle, comme celle d\'un enfant au fond d\'un puits.%SPEECH_ON%Poursuivez-nous ! Par ici ! Poursuivez-nous ! Poursuivez-nous... POURSUIVEZ-NOUS. POURSUIVEZ-NOUS MAINTENANT !%SPEECH_OFF%Vous ne ressentez soudain aucune envie de récupérer le grain. Vous remettez lentement votre épée dans son fourreau et sortez du champ. Alors que vous regardez fixement les hautes herbes, elles commencent à se séparer, lentement, comme un morceau de cuir que l\'on déchire aux coutures. Vous entendez des cris horribles lorsque chaque tige se brise en deux.\n\n%randombrother% vous fait sursauter quand il vous demande ce que vous êtes en train de faire. Vous vous tournez pour le regarder, puis vous vous retournez vers le champ qui se balance doucement au gré de la brise. Au lieu de répondre, vous lui dites simplement de se préparer car vous allez bientôt reprendre la marche. Heureusement, le mercenaire ne s\'enquiert pas de la nourriture manquante.}";
				}

				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous perdez " + food.getName()
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 10)
		{
			return;
		}

		if (this.World.Assets.getFood() < 70)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.cook"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Swamp && currentTile.Type != this.Const.World.TerrainType.Farmland && currentTile.Type != this.Const.World.TerrainType.Steppe && currentTile.Type != this.Const.World.TerrainType.Hills)
		{
			return;
		}

		this.m.Score = this.World.Assets.getFood() / 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.FoodAmount = 0;
	}

});

